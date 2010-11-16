require 'test_helper'

class EntryTest < ActiveSupport::TestCase
include EntryHelper
  def test_findAll
	@entries = Entry.find(:all)
	assert @entries.length == 4 
	assert_not_equal @entries.length, 2
  end

  def test_Save
	@entries = Entry.find(:first, :conditions => ['id =?', '1'])
	assert @entries.save
  end

  def test_getUserReportBy
	@reportBy = getUserReportBy
	assert_equal 4,  @reportBy.length
  end

  def test_getUserReportSubOptions_date_daily
	@subOptions = getUserReportSubOptions('Date', 'Daily')
	assert_equal 7, @subOptions.length
  end

  def test_getUserReportSubOptions_date_weekly
	@subOptions = getUserReportSubOptions('Date', 'Weekly')
	assert_equal 5, @subOptions.length 
  end

  def test_getUserReportSubOptions_date_monthly
	@subOptions = getUserReportSubOptions('Date', 'Monthly')
	assert_equal 12, @subOptions.length 
  end

  def test_getUserReportSubOptions_date_quartely
	@subOptions = getUserReportSubOptions('Date', 'Quartely')
	assert_equal 4, @subOptions.length
  end

  def test_getUserReportSubOptions_date_yearly
	@subOptions = getUserReportSubOptions('Date', 'Yearly')
	assert_equal 10, @subOptions.length
  end

  def test_getUserReportSubOptions_date_nil
	assert_equal Array.new, getUserReportSubOptions('Date', '')
  end

  def test_getUserReportSubOptions_NotDate
	assert_equal 7, getUserReportSubOptions('Project', '').length
	assert_equal 7, getUserReportSubOptions('Chartered', '').length
	assert_equal 7, getUserReportSubOptions('nonchartered', '').length
	assert_equal nil, getUserReportSubOptions('nil', '')
  end

  def test_getUserReportSubSubOptions_Date
	@subOptions =  getUserReportSubSubOptions('Date')
	assert_equal nil, @subOptions.index('Date')
  end

  def test_getUserReportSubSubOptions_Project
	@subOptions =  getUserReportSubSubOptions('Project')
	assert_equal nil, @subOptions.index('Project')
  end

  def test_getUserReportSubSubOptions_Chartered
	@subOptions =  getUserReportSubSubOptions('Chartered')
	assert_equal nil, @subOptions.index('Chartered')
  end

  def test_getUserReportSubSubOptions_NonChartered
	@subOptions =  getUserReportSubSubOptions('Nonchartered')
	assert_equal nil, @subOptions.index('Nonchartered')
  end

  def test_userDateRangeCalculator_date_daily
	time = DateTime.new(2010, 01, 01)
	@dateOptions = userDateRangeCalculator('Date', '', time)
	assert_equal 2, @dateOptions.length
	assert_equal nil, @dateOptions[0]
	@dateOptions = userDateRangeCalculator('Date', 'Daily_Mon_Nov_08', time)
	assert_equal 2, @dateOptions.length
	assert_equal '2010-11-08T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2010-11-09T00:00:00+00:00', @dateOptions[1].to_s
	@dateOptions = userDateRangeCalculator('Date', 'Daily_Mon_Nov_ 01', time)
        assert_equal 2, @dateOptions.length
        assert_equal '2010-11-01T00:00:00+00:00', @dateOptions[0].to_s
        assert_equal '2010-11-02T00:00:00+00:00', @dateOptions[1].to_s
	@dateOptions = userDateRangeCalculator('Date', 'Daily_Sun_Oct_ 31', time)
        assert_equal 2, @dateOptions.length
        assert_equal '2010-10-31T00:00:00+00:00', @dateOptions[0].to_s
        assert_equal '2010-11-01T00:00:00+00:00', @dateOptions[1].to_s
	@dateOptions = userDateRangeCalculator('Date', 'Daily_Fri_Dec_ 31', time)
        assert_equal 2, @dateOptions.length
        assert_equal '2010-12-31T00:00:00+00:00', @dateOptions[0].to_s
        assert_equal '2011-01-01T00:00:00+00:00', @dateOptions[1].to_s
	#leap year
	time = DateTime.new(2012, 01, 01)
	@dateOptions = userDateRangeCalculator('Date', 'Daily_Tue_Feb_28', time)
        assert_equal '2012-02-28T00:00:00+00:00', @dateOptions[0].to_s
        assert_equal '2012-02-29T00:00:00+00:00', @dateOptions[1].to_s
	@dateOptions = userDateRangeCalculator('Date', 'Daily_Wed_Feb_29', time)
        assert_equal '2012-02-29T00:00:00+00:00', @dateOptions[0].to_s
        assert_equal '2012-03-01T00:00:00+00:00', @dateOptions[1].to_s
  end


  def test_userDateRangeCalculator_date_weekly
	time = DateTime.new(2010, 01, 01)
	@dateOptions = userDateRangeCalculator('Date', 'Weekly_Sun Nov 07 - Sat Nov 13', time)
	assert_equal '2010-11-07T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2010-11-14T00:00:00+00:00', @dateOptions[1].to_s
	@dateOptions = userDateRangeCalculator('Date', 'Weekly_Sun Dec 26 - Sat Jan 01', time)
	assert_equal '2010-12-26T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2011-01-02T00:00:00+00:00', @dateOptions[1].to_s
        @dateOptions = userDateRangeCalculator('Date', 'Weekly_Sun Nov 28 - Sat Dec 04', time)
        assert_equal '2010-11-28T00:00:00+00:00', @dateOptions[0].to_s
        assert_equal '2010-12-05T00:00:00+00:00', @dateOptions[1].to_s
  end

  def test_userDateRangeCalculator_date_monthly
	time = DateTime.new(2010, 01, 01)
        @dateOptions = userDateRangeCalculator('Date', 'Monthly_November 2010', time)
        assert_equal '2010-11-01T00:00:00+00:00', @dateOptions[0].to_s
        assert_equal '2010-12-01T00:00:00+00:00', @dateOptions[1].to_s
	@dateOptions = userDateRangeCalculator('Date', 'Monthly_December 2010', time)
        assert_equal '2010-12-01T00:00:00+00:00', @dateOptions[0].to_s
        assert_equal '2011-01-01T00:00:00+00:00', @dateOptions[1].to_s
  end

  def test_userDateRangeCalculator_date_quartely
	time = DateTime.new(2010, 01, 01)
	@dateOptions = userDateRangeCalculator('Date', 'Quartely_Quarter 4 2010', time)
	assert_equal '2010-10-01T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2011-01-01T00:00:00+00:00', @dateOptions[1].to_s
	@dateOptions = userDateRangeCalculator('Date', 'Quartely_Quarter 1 2010', time)
	assert_equal '2010-01-01T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2010-04-01T00:00:00+00:00', @dateOptions[1].to_s
	@dateOptions = userDateRangeCalculator('Date', 'Quartely_Quarter 2 2010', time)
	assert_equal '2010-04-01T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2010-07-01T00:00:00+00:00', @dateOptions[1].to_s
	@dateOptions = userDateRangeCalculator('Date', 'Quartely_Quarter 3 2010', time)
	assert_equal '2010-07-01T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2010-10-01T00:00:00+00:00', @dateOptions[1].to_s
  end

  def test_userDateRangeCalculator_date_yearly
	tyear = 2010
	(8..0).each do |h|
		year = tyear - h
		@dateOptions = userDateRangeCalculator('Date', 'Yearly_'+year.to_s, " ")
		assert_equal year.to_s+'-01-01T00:00:00+00:00', @dateOptions[0].to_s
		assert_equal ((year+1).to_s'-01-01T00:00:00+00:00'), @dateOptions[1].to_s
	end
  end

  def test_userDateRangeCalculator_thisWeek
	time 		= DateTime.new(2010, 11, 10)
	@dateOptions	= userDateRangeCalculator('Project', 'This Week', time)
	assert_equal '2010-11-07T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2010-11-14T00:00:00+00:00', @dateOptions[1].to_s
  end

  def test_userDateRangeCalculator_LastWeek
	time		= DateTime.new(2010, 11, 10)
	@dateOptions	= userDateRangeCalculator('Chartered', 'Last Week', time)
	assert_equal '2010-10-31T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2010-11-07T00:00:00+00:00', @dateOptions[1].to_s
  end

  def test_userDateRangeCalculator_ThisMonth
	time		= DateTime.new(2010, 11, 16)
	@dateOptions	= userDateRangeCalculator('Chartered', 'This Month', time)
	assert_equal '2010-11-01T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2010-12-01T00:00:00+00:00', @dateOptions[1].to_s
	time		= DateTime.new(2010, 12, 16)
	@dateOptions	= userDateRangeCalculator('Chartered', 'This Month', time)
	assert_equal '2010-12-01T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2011-01-01T00:00:00+00:00', @dateOptions[1].to_s
  end

  def test_userDateRangeCalculator_LastMonth
	time		= DateTime.new(2010, 11, 16)
	@dateOptions	= userDateRangeCalculator('Chartered', 'Last Month', time)
	assert_equal '2010-10-01T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2010-11-01T00:00:00+00:00', @dateOptions[1].to_s
  end

  def test_userDateRangeCalculator_ThisQuarter
	time		= DateTime.new(2010, 07, 30)
	@dateOptions	= userDateRangeCalculator('Project', 'This Quarter', time)
	assert_equal '2010-07-01T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2010-10-01T00:00:00+00:00', @dateOptions[1].to_s
	time		= DateTime.new(2010, 10, 20)
	@dateOptions	= userDateRangeCalculator('Project', 'This Quarter', time)
	assert_equal '2010-10-01T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2011-01-01T00:00:00+00:00', @dateOptions[1].to_s
	time		= DateTime.new(2011, 12, 30)
	@dateOptions	= userDateRangeCalculator('Project', 'This Quarter', time)
	assert_equal '2011-10-01T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2012-01-01T00:00:00+00:00', @dateOptions[1].to_s
  end

  def test_userDateRangeCalculator_LastQuarter
	time		= DateTime.new(2010, 07, 30)
	@dateOptions	= userDateRangeCalculator('Project', 'Last Quarter', time)
	assert_equal '2010-04-01T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2010-07-01T00:00:00+00:00', @dateOptions[1].to_s
	time		= DateTime.new(2010, 03, 30)
	@dateOptions	= userDateRangeCalculator('Project', 'Last Quarter', time)
	assert_equal '2009-10-01T00:00:00+00:00', @dateOptions[0].to_s
	assert_equal '2010-01-01T00:00:00+00:00', @dateOptions[1].to_s
  end

end
