require 'test_helper'
require 'active_support/core_ext/array/access'
require 'geared_pagination/portion'

class GearedPagination::PortionTest < ActiveSupport::TestCase
  test "offset" do
    assert_equal 0, GearedPagination::Portion.new(page_number: 1).offset
    assert_equal GearedPagination::Ratios::DEFAULTS.first, GearedPagination::Portion.new(page_number: 2).offset
    assert_equal GearedPagination::Ratios::DEFAULTS.first + GearedPagination::Ratios::DEFAULTS.second, GearedPagination::Portion.new(page_number: 3).offset
  end

  test "limit" do
    assert_equal GearedPagination::Ratios::DEFAULTS.first, GearedPagination::Portion.new(page_number: 1).limit
    assert_equal GearedPagination::Ratios::DEFAULTS.second, GearedPagination::Portion.new(page_number: 2).limit
  end

  test "cache key changes according to current page and gearing" do
    assert_equal '2:3', cache_key(page: 2, per_page: 3)
    assert_equal '2:1-3', cache_key(page: 2, per_page: [ 1, 3 ])
    assert_equal '2:2-3', cache_key(page: 2, per_page: [ 2, 3 ])
  end

  private
    def cache_key(page:, per_page:)
      GearedPagination::Portion.new(page_number: page, per_page: GearedPagination::Ratios.new(per_page)).cache_key
    end
end
