module CapybaraTestHelper
  def assert_rich_text_area(locator, **options, &block)
    assert_selector :rich_text_area, locator, **options, &block
  end

  def assert_no_rich_text_area(locator, **options)
    assert_no_selector :rich_text_area, locator, **options
  end
end

Capybara.modify_selector :rich_text_area do
  filter_set(:capybara_accessible_selectors, %i[focused fieldset described_by validation_error])
end
