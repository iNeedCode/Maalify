json.array!(@pdf_reporters) do |pdf_reporter|
  json.extract! pdf_reporter, :id, :name, :members
  json.url pdf_reporter_url(pdf_reporter, format: :json)
end
