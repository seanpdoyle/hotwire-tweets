module TweetsTestHelper
  def assert_tweet(tweet, **options)
    assert_selector :tweet, tweet, **options
  end

  def assert_no_tweet(tweet, **options)
    assert_no_selector :tweet, tweet, **options
  end

  def assert_retweet(retweet, **options)
    assert_selector :tweet, retweet.parent, **options
  end

  def assert_no_retweet(retweet, **options)
    assert_no_selector :tweet, retweet.parent, **options
  end

  def within_tweet(tweet, **options, &block)
    within :tweet, tweet, match: :first, **options, &block
  end

  def within_retweet(retweet, **options, &block)
    within :tweet, retweet.parent, match: :first, **options, &block
  end
end

Capybara.add_selector(:tweet, locator_type: [String, Tweet, Entry]) do
  xpath do |tweet, position: nil, **options|
    text =
      if tweet.respond_to?(:content)
        tweet.content.to_plain_text
      else
        tweet.to_s
      end

    xpath = XPath.css("article")

    if position.present?
      xpath = xpath[position.to_i]
    end

    xpath[XPath.string.n.is(text)]
  end
end
