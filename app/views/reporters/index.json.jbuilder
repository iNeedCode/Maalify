json.array!(@reporters) do |reporter|
  json.extract! reporter, :id, :name, :donations, :tanzeems, :interval, :emails
  json.url reporter_url(reporter, format: :json)
end
