require 'sinatra'
require 'rest-client'
require 'json'

def rest 
  resource ||= RestClient::Resource.new((ENV['NEO4J_URL'] || "http://localhost:8080") + "/api/query.json")
end

# TODO load queries
# todo provide queries as params for /reports

def new_pings_by_source_per_day(time) 
 year=time.year
 month=sprintf("%02d",time.month)
 {:query => "start root=node(0)
 match root -[:`#{year}`]-> year -[:`#{month}`] -> month -[d]-> day,
 storeId <-[:NEW_INSTANCE_DATE]-day,
 storeId -[:SOURCE]->source
 return type(d) as day, source.SOURCE as source, count(*) as cnt
 order by type(d) asc",
 :params => {}}
end 

def query(query)
  check(query)
  puts query.inspect
  result = rest.post query.to_json, {:accept=>"plain/text",:content_type=>"application/json"}
  puts result
  # JSON.parse(result.to_s)
  return result
end

def check(query)
  if query.kind_of?(String)
    raise("No updating queries allowed "+query) unless ( query =~ /(create|delete|set|create unique)/i ).nil?
    return
  end
   
  return check(query[:query]) if (query.kind_of? Hash)
  query.each { |q| check(q)  } if (query.kind_of? Array)
end

get '/reports' do
    content_type :text
    date = Time.now
    date = Time.parse(params[:date]) if params[:date]
    result = query([new_pings_by_source_per_day(date),new_pings_by_source_per_day(date)])
    return [200, result] if result
    return 400
end

get '/' do
'
<a href="/reports" target="reports">Reports</a>
<form method="get" action="/reports" target="reports">
  <input name="date" type="text" value="2012-06-01"/>
  <input type="submit" value="Load"/>
</form>
'
end

puts query({:query => "start n=node({id}) return n", :params => {:id => 0 }}).inspect
