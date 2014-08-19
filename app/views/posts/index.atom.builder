atom_feed language: 'en-US' do |feed|
  feed.title @resource.pluralize
  feed.updated Time.now

  @posts.each do |post|
    feed.entry(post, url: "#{CONFIG[:root_url]}/#{post.post_type.tableize}/#{post.slug}") do |entry|
      entry.id post.id, type: 'integer'
      entry.title post.title
      entry.date_posted post.date_posted, type: 'dateTime'
      entry.updated post.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")
      entry.slug post.slug
      entry.content post.content
     
      entry.author do |author|
        author.name post.user.name
      end
    end
  end
end
