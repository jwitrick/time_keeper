module EntryHelper

	def getDateItems(date_type, date_range, date_subtype)
		date_type		= 'Daily' if date_type == nil
		date_range_opt		= getUserReportSubOptions('Date', date_type)
		date_type_opt		= getDateTypeOptions
		date_type_sel		= date_type 
		date_range		= date_range_opt[0] if date_range == nil or date_range_opt.index(date_range.gsub(/_/, " ")) == nil
		date_range_sel		= date_range
		date_sub_opt		= getUserReportSubSubOptions('Date')
		date_subtype		= date_sub_opt[0] if date_subtype == nil
		date_subtype_sel	= date_subtype
		output = Array.new
		output.push(date_type_opt)
		output.push(date_type_sel)
		output.push(date_range_opt)
		output.push(date_range_sel)
		output.push(date_sub_opt)
		output.push(date_subtype_sel)
		return output
	end
	def getUserReportBy
		report = Array.new
		report.push('Date')
		report.push('Project')
		report.push('Chartered')
		report.push('NonChartered')
		return report
	end
	def getUserReportSubOptions(selected_type, selected_value)
		#puts YAML::dump("selected type is: #{selected_type}")
		subOptions = Array.new
		if selected_type.to_s.downcase == 'date'
			if selected_value == 'Daily'
				subOptions = getDailyReportSelector
			elsif selected_value == 'Weekly'
				subOptions = getWeeklyReportSelector
			elsif selected_value == 'Monthly'
				subOptions = getMonthlyReportSelector
			elsif selected_value == 'Quartely'
				subOptions = getQuartelyReportSelector
			elsif selected_value == 'Yearly'
				subOptions = getYearlyReportSelector
			else
				#Should not get here.
			end
		elsif selected_type.to_s.downcase == 'project'
			subOptions = getDateRangeOptions
		elsif selected_type.to_s.downcase == 'chartered'
			subOptions = getDateRangeOptions
		elsif selected_type.to_s.downcase == 'nonchartered'
			subOptions = getDateRangeOptions
		else
			return nil
		end
		return subOptions
	end
	def getUserReportSubSubOptions(selected_type)
		subOptions = Array.new
                subOptions = getUserReportBy
		subOptions.delete(selected_type)
                return subOptions
	end
	def getDateTypeOptions
		dateOptions = Array.new
		dateOptions.push("Daily")
		dateOptions.push("Weekly")
		dateOptions.push("Monthly")
		dateOptions.push("Quartely")
		dateOptions.push("Yearly")
		return dateOptions
	end
	def getDailyReportSelector
		daily = Array.new
		time = Time.new
		(0..6).each do|i|
			tmp = time.advance :days => -i 
			daily.push(tmp.strftime("%a %b %d"))
		end
		return daily
	end
	def getWeeklyReportSelector
		range = Array.new
		time = Time.new
		day_o_w	= time.strftime("%w")
		time = time.advance :days => -(day_o_w).to_i
		(0..4).each do |i|
			start_week 	= time.advance :days => -(i*7).to_i
			end_week	= start_week.advance :days => 6
			range.push(start_week.strftime("%a %b %d")+" - "+end_week.strftime("%a %b %d"))
		end
		return range
	end
	def getMonthlyReportSelector
		range = Array.new
		time = Time.new
		(0..11).each do |i|
			month 	= time.advance :months => -i
			range.push(month.strftime("%B %Y"))
		end
		return range
	end
	def getQuartelyReportSelector
		range = Array.new
		time = Time.new
		mon_num				= time.strftime("%m").to_f
		quarter_num			= (mon_num/3).ceil
		(0..3).each do |i|	
			quarter = quarter_num -i
			if quarter < 1
				quarter == 4
				quarter_num = quarter
				time = time.advance :years => -1
			end
			range.push("Quarter "+quarter.to_s+" "+time.strftime("%Y"))
		end
		return range
	end
	def getYearlyReportSelector
		range = Array.new
		time = Time.new
		(0..9).each do |i|
			report_year = time.advance :years => -i
			range.push(report_year.strftime("%Y"))
		end
		return range	
	end
	def getDateRangeOptions
		projectRange = Array.new
		projectRange.push("This Week")
		projectRange.push("Last Week")
		projectRange.push("This Month")
		projectRange.push("Last Month")
		projectRange.push("This Quarter")
		projectRange.push("Last Quarter")
		projectRange.push("All")
		return projectRange
	end
	def userDateRangeCalculator(report_type, value, time)
		if report_type == 'Date'
			range			= value.split('_')
			date_type 		= range[0]
			if date_type == 'Daily'
				month_num	= getMonthNumByName(range[2])
				start_date	= DateTime.new(time.strftime("%Y").to_i, month_num, range[3].to_i)
				end_date	= start_date.advance :days => 1
			elsif date_type == 'Weekly'
				date_range 	= range[1].split(' - ')
				start_date_a	= date_range[0].split(' ')
				start_month_n	= getMonthNumByName(start_date_a[1])
				end_date_array	= date_range[1].split(' ')
				end_month_num	= getMonthNumByName(end_date_array[1])
				start_date	= DateTime.new(time.strftime("%Y").to_i, start_month_n, start_date_a[2].to_i)
				end_date	= start_date.advance :days => 7	
			elsif date_type == 'Monthly'
				date_range		= range[1].split(' ')
				start_month_num		= getMonthNumByName(date_range[0])
				start_date		= DateTime.new(date_range[1].to_i, start_month_num, 1)
				end_date		= start_date.advance :months => 1
			elsif date_type == 'Quartely'
				date_range		= range[1].split(' ')
				start_month_num		= getQuarterStartMonth(date_range[1].to_i)
				start_date		= DateTime.new(date_range[2].to_i, start_month_num, 1)
				end_date		= start_date.advance :months => 3				
			elsif date_type == 'Yearly'
				date_range		= range[1]
				start_date		= DateTime.new(date_range.to_i, 1, 1)
				end_date		= start_date.advance :years => 1
			else
			end
		else
			day_of_week				= time.strftime("%w")
			day_of_month				= time.strftime("%d")
			if value == 'This Week'	
				start_date			= time.advance :days => -(day_of_week).to_i
				end_date			= start_date.advance :days => 7
			elsif value == 'Last Week'
				end_date			= time.advance :days => -(day_of_week).to_i
				start_date			= end_date.advance :days => -7
			elsif value == 'This Month'
				start_date			= time.advance :days => -(day_of_month).to_i + 1
				end_date			= start_date.advance :months => 1
			elsif value == 'Last Month'
				end_date			= time.advance :days => -(day_of_month).to_i + 1
				start_date			= end_date.advance :months => -1
			elsif value == 'This Quarter' || value == 'Last Quarter'
				mon_num				= time.strftime("%m").to_f
				quarter_num			= (mon_num/3).ceil
				if value == 'This Quarter'
					startMonth		= getQuarterStartMonth(quarter_num)
					start_date		= DateTime.new(time.strftime("%Y").to_i, startMonth, 1) 
					end_date		= start_date.advance :months => 3
				else
					endMonth		= getQuarterStartMonth(quarter_num)
					end_date		= DateTime.new(time.strftime("%Y").to_i, endMonth, 1)
					start_date		= end_date.advance :months => -3
				end
			end	
		end
		output = Array.new
		output.push(start_date)
		output.push(end_date)
		return output
	end
	def getMonthNumByName(month_name)
		value = 0
		(1..12).each do |m|
			if Date::MONTHNAMES[m] == month_name or Date::MONTHNAMES[m][0, 3] == month_name
				value = m
			end	
		end
		return value
	end
	def getQuarterStartMonth(quarter_num)
		quarter_num = quarter_num.to_s
		if quarter_num == '1'
			return 1
		elsif quarter_num == '2'
			return 4
		elsif quarter_num == '3'
			return 7
		else
			return 10
		end
	end

	def createUserReportQuery(data)
		sql = "select * from entries where user_id = '"+data[0].to_s+"' and date >= '"+data[1].strftime("%Y-%m-%d 00:00:00")+"' and date < '"+data[2].strftime("%Y-%m-%d")+"' ORDER BY project_id ASC"
		return Entry.find_by_sql(sql)
	end
end
