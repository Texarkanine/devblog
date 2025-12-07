=begin
Jekyll plugin to obfuscate email addresses using JavaScript assembly and ROT-N encoding.

This plugin splits email addresses into chunks, encodes them with ROT-N (where N is
the length of a random span class name), and stores them in randomized data attributes.
The email is assembled via JavaScript on mouseover/click, so it never appears whole
in the HTML source.

Copyright (C) 2025
=end

require 'securerandom'

module Jekyll
    class EmailTag < Liquid::Tag
        # Generate random constants once per build
        # Two-part class names: <part1>-<part2> where each part is 3-16 chars
        # Must start with a letter for valid CSS selectors
        @@span_part1 = (('a'..'z').to_a.sample + SecureRandom.alphanumeric(rand(3..16))).downcase
        @@span_part2 = (('a'..'z').to_a.sample + SecureRandom.alphanumeric(rand(3..16))).downcase
        @@span_class = "#{@@span_part1}-#{@@span_part2}"
        @@link_part1 = (('a'..'z').to_a.sample + SecureRandom.alphanumeric(rand(3..16))).downcase
        @@link_part2 = (('a'..'z').to_a.sample + SecureRandom.alphanumeric(rand(3..16))).downcase
        @@link_class = "#{@@link_part1}-#{@@link_part2}"
        @@rot_function_name = (('a'..'z').to_a.sample + SecureRandom.alphanumeric(rand(7..15))).downcase  # Random function name for ROT
        
        # Generate random data attribute names for email chunks
        # We'll split email into: mailto, user, domain_base, tld (no @ or : in data attrs)
        # Must start with a letter for valid HTML attributes
        @@data_attrs = [
            "data-" + (('a'..'z').to_a.sample + SecureRandom.alphanumeric(rand(5..11))).downcase,  # mailto
            "data-" + (('a'..'z').to_a.sample + SecureRandom.alphanumeric(rand(5..11))).downcase,  # user
            "data-" + (('a'..'z').to_a.sample + SecureRandom.alphanumeric(rand(5..11))).downcase,  # domain_base
            "data-" + (('a'..'z').to_a.sample + SecureRandom.alphanumeric(rand(5..11))).downcase   # tld
        ]
        
        # Track if CSS/JS has been injected
        @@injection_key = "__email_css_js_injected_#{@@span_class}"

        def initialize(tag_name, text, tokens)
            super
            @email = text
        end

        def render(context)
            # Inject CSS and JS the first time this tag is used on the page
            css_js_key = "#{@@injection_key}"
            css_js_injected = context[css_js_key]
            
            css_js_output = ""
            if !css_js_injected
                context.scopes.last[css_js_key] = true
                css_js_output = self.class.get_css_js
            end
            
            # Try to resolve as a Liquid variable first
            email_value = context[@email.strip]
            email = email_value.nil? ? @email.strip : email_value.to_s.strip
            
            # Split email into components
            values = email.split("@")
            if values.length != 2 || values.any?(&:empty?)
                raise ArgumentError, "Invalid email format: #{email}"
            end
            user_part = values[0]
            domain_full = values[1]
            
            # Split domain at first dot
            domain_parts = domain_full.split(".", 2)
            if domain_parts.length < 2 || domain_parts.any?(&:empty?)
                raise ArgumentError, "Invalid email domain format: #{domain_full}"
            end
            domain_base = domain_parts[0]
            domain_tld = domain_parts[1]
            
            # ROT-N encode each component with different N values
            # mailto: span class first part length (no ":" - add in JS)
            mailto_encoded = rot_n_encode("mailto", @@span_part1.length)
            # user: span class second part length
            user_encoded = rot_n_encode(user_part, @@span_part2.length)
            # domain_base: link class first part length
            domain_base_encoded = rot_n_encode(domain_base, @@link_part1.length)
            # tld: link class second part length
            domain_tld_encoded = rot_n_encode(domain_tld, @@link_part2.length)
            
            # Build the span with encoded chunks in randomized data attributes
            # Initial display is placeholder text, email revealed on mouseover
            # No @ or : in data attributes - add those in JavaScript
            email_link = "<a href=\"#\" class=\"#{@@link_class}\">" +
                "<span class=\"#{@@span_class}\" " +
                "#{@@data_attrs[0]}=\"#{mailto_encoded}\" " +
                "#{@@data_attrs[1]}=\"#{user_encoded}\" " +
                "#{@@data_attrs[2]}=\"#{domain_base_encoded}\" " +
                "#{@@data_attrs[3]}=\"#{domain_tld_encoded}\">XXXXXXXXXXXXXXXX</span>" +
            "</a>"
            
            # Wrap script/style in {::nomarkdown} tags to prevent Kramdown from escaping < and >
            # Only add these tags when rendering Markdown (posts), not HTML templates (layouts)
            # Check if we're in a Markdown context by looking at the page path
            page = context['page']
            is_markdown = page && page['path'] && (page['path'].end_with?('.md') || page['path'].end_with?('.markdown'))
            
            if css_js_output.empty?
                email_link
            elsif is_markdown
                "{::nomarkdown}#{css_js_output}{:/nomarkdown}#{email_link}"
            else
                "#{css_js_output}#{email_link}"
            end
        end

        def rot_n_encode(text, n)
            # ROT-N encode: shift each letter by N positions
            text.each_char.map do |char|
                if char.match?(/[a-zA-Z]/)
                    base = char.ord < 91 ? 65 : 97  # A=65, a=97
                    ((char.ord - base + n) % 26 + base).chr
                else
                    char  # Keep non-letters as-is
                end
            end.join
        end
        
        def self.rot_n_decode(text, n)
            # ROT-N decode: shift back by N positions
            text.each_char.map do |char|
                if char.match?(/[a-zA-Z]/)
                    base = char.ord < 91 ? 65 : 97
                    ((char.ord - base - n) % 26 + base).chr
                else
                    char
                end
            end.join
        end
        
        def self.get_css_js
            # Generate CSS and JavaScript for decoding and display
            span_class = @@span_class
            link_class = @@link_class
            rot_func = @@rot_function_name
            attrs = @@data_attrs
            
            # Generate random function names to make it less obvious
            # Must start with a letter for valid JS identifiers
            decode_func = (('a'..'z').to_a.sample + SecureRandom.alphanumeric(rand(7..15))).downcase
            attach_func = (('a'..'z').to_a.sample + SecureRandom.alphanumeric(rand(7..15))).downcase
            attr_names = [
                (('a'..'z').to_a.sample + SecureRandom.alphanumeric(rand(5..11))).downcase,
                (('a'..'z').to_a.sample + SecureRandom.alphanumeric(rand(5..11))).downcase,
                (('a'..'z').to_a.sample + SecureRandom.alphanumeric(rand(5..11))).downcase,
                (('a'..'z').to_a.sample + SecureRandom.alphanumeric(rand(5..11))).downcase
            ]
            
            css = "span.#{span_class} { display: inline-block; }"
            
            # JavaScript that reads ROT-N from class name parts and decodes
            js = "<script>" +
                "(function(){" +
                "function #{rot_func}(s,n){" +
                "var r='';" +
                "for(var i=0;i<s.length;i++){" +
                "var c=s.charCodeAt(i);" +
                "if(c>=65&&c<=90){r+=String.fromCharCode((c-65-n+26)%26+65);}" +
                "else if(c>=97&&c<=122){r+=String.fromCharCode((c-97-n+26)%26+97);}" +
                "else r+=s[i];" +
                "}" +
                "return r;" +
                "}" +
                "function #{decode_func}(sp,lnk){" +
                "var spParts=sp.className.split('-');" +
                "var lnkParts=lnk.className.split('-');" +
                "var #{attr_names[0]}=sp.getAttribute('#{attrs[0]}');" +
                "var #{attr_names[1]}=sp.getAttribute('#{attrs[1]}');" +
                "var #{attr_names[2]}=sp.getAttribute('#{attrs[2]}');" +
                "var #{attr_names[3]}=sp.getAttribute('#{attrs[3]}');" +
                "var mailto=#{rot_func}(#{attr_names[0]},spParts[0].length);" +
                "var user=#{rot_func}(#{attr_names[1]},spParts[1].length);" +
                "var domainBase=#{rot_func}(#{attr_names[2]},lnkParts[0].length);" +
                "var tld=#{rot_func}(#{attr_names[3]},lnkParts[1].length);" +
                "return mailto+':'+user+'@'+domainBase+'.'+tld;" +
                "}" +
                "function #{attach_func}(){" +
                "var els=document.querySelectorAll('a.#{link_class}');" +
                "var handler=function(){" +
                "var sp=this.querySelector('span.#{span_class}');" +
                "if(sp&&!this.dataset.d){" +
                "var val=#{decode_func}(sp,this);" +
                "this.href=val;" +
                "sp.textContent=val.replace('mailto:','');" +
                "this.dataset.d='1';" +
                "}" +
                "};" +
                "for(var i=0;i<els.length;i++){" +
                "els[i].addEventListener('mouseover',handler);" +
                "els[i].addEventListener('focus',handler);" +
                "}" +
                "}" +
                "if(document.readyState==='loading'){" +
                "document.addEventListener('DOMContentLoaded',#{attach_func});" +
                "}else{#{attach_func}();}" +
                "})();" +
                "</script>"
            
            "<style>#{css}</style>#{js}"
        end

        private :rot_n_encode
    end
end

Liquid::Template.register_tag('email', Jekyll::EmailTag)
