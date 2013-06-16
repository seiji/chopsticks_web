module Summary
    def self.included(receiver)
      receiver.class_eval do
        field :title, type: String
        field :url, type: String
        field :author, type: String
        field :summary, type: String
        field :content, type: String
        field :published, type:DateTime 
        field :reads, type: Integer
        validates_presence_of :title
        validates_presence_of :url
      end
    end
end

class Entry
  include Mongoid::Document
  include Mongoid::Timestamps
  include Summary

  belongs_to :feed, touch: true
  index({ url: 1 }, { unique: true,  background: true })

  after_save do |document|
    unless self.published
      self.update_attribute(:published, self.updated_at)
    end
  end

  def body
    return @body if @body
    text = self.content || self.summary
    text.gsub!(/src=([\'|\"]{1})\//i, "src=\\1#{feed.url}/")
    tag = 0
    text.gsub!(/<h[1-6]>.*?<\/h[1-6]>/i) do | matched |
      "<a name='#{tag += 1}'>#{matched}</a>"
    end
    @body = text
    text
  end

  def headers
    return @headers if @headers
    array = extract_headers
    @headers = array
  end

  private
  def extract_headers
    array = []
    (1..6).each do |i|
      self.body.scan(/<h#{i}>(.*?)<\/h#{i}>/im) do |matched|
        matched.each do |s|
          if block_given? 
            yield(s, i)
          end
          array << "<span class='h#{i}'>#{s}</span>"
        end
      end
    end
    array
  end
end

