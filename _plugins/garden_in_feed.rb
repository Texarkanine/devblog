# frozen_string_literal: true

require "jekyll-feed"

module GardenInMainFeed
  # Prepended onto JekyllFeed::Generator so the posts Atom feed lists garden
  # and writing documents beside posts.
  #
  # feed_template returns the gem template. When the posts assignment is
  # present, the posts feed concatenates site.garden and site.writing, each
  # only when that collection exists, before the draft filter and the date
  # sort. Tag feeds and other collection feeds keep their own assignment.
  # A missing assignment leaves the gem template unchanged.
  POSTS_ASSIGN = "{% assign posts = site[page.collection] %}"
  WITH_COLLECTIONS = "{% assign posts = site[page.collection] %}" \
    "{% if page.collection == \"posts\" %}" \
    "{% if site.garden %}{% assign posts = posts | concat: site.garden %}{% endif %}" \
    "{% if site.writing %}{% assign posts = posts | concat: site.writing %}{% endif %}" \
    "{% endif %}"

  def feed_template
    template = super
    return template unless template.include?(POSTS_ASSIGN)
    template.sub(POSTS_ASSIGN, WITH_COLLECTIONS)
  end
end

JekyllFeed::Generator.prepend(GardenInMainFeed)
