# frozen_string_literal: true

require "jekyll-feed"

module GardenInMainFeed
  # Prepended onto JekyllFeed::Generator so the posts Atom feed lists garden
  # documents beside posts.
  #
  # feed_template returns the gem template. When the posts assignment is
  # present, the posts feed concatenates site.garden before the draft filter
  # and the date sort. Tag feeds and other collection feeds keep their own
  # assignment. A missing assignment leaves the gem template unchanged.
  POSTS_ASSIGN = "{% assign posts = site[page.collection] %}"
  WITH_GARDEN = "{% assign posts = site[page.collection] %}" \
    "{% if page.collection == \"posts\" and site.garden %}" \
    "{% assign posts = posts | concat: site.garden %}" \
    "{% endif %}"

  def feed_template
    template = super
    return template unless template.include?(POSTS_ASSIGN)
    template.sub(POSTS_ASSIGN, WITH_GARDEN)
  end
end

JekyllFeed::Generator.prepend(GardenInMainFeed)
