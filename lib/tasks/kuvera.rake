require 'csv'
namespace :kuvera do
  desc "Bootstrap the app with data from mutual fund website"
  task bootstrap: :environment do
    axis_mutual_fund = MutualFund.create!(name: 'axis_mutual_fund')
    nav_history_array = []
    start_time = Time.now
    puts "================ start time is #{start_time}"
    CSV.foreach('config/axis_mutual_fund.csv', {headers: true, col_sep: ";"}) do |row|
      hash = row.to_hash
      next unless hash.present? && row.to_s.split(';').length > 0
      next if row.to_s.include?("Open Ended Schemes") || row.to_s.include?("Mutual Fund")
      hash = hash.merge({ "mutual_fund_id"=> axis_mutual_fund.id, "date" => Date.parse(hash['date']), "created_at" => DateTime.now, "updated_at" => DateTime.now})
      nav_history_array.push(hash)
    end

    puts "===================== #{nav_history_array.count}"

    columns = nav_history_array.first.keys

    to_insert = nav_history_array.map do |d|
      vals = columns.map {|k| d[k] }
      ActiveRecord::Base.send(:replace_bind_variables, "(#{vals.length.times.collect {'?'}.join(',')})", vals)
    end

    ActiveRecord::Base.connection.execute(<<-SQL)
    INSERT INTO
      #{NavHistory.table_name}
    (#{columns.join(',')})
    VALUES #{to_insert.join(",")}
    SQL

    puts "======================== end time is: #{Time.now - start_time} seconds"

  end

end
