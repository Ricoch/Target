json.targets do
  json.array!(@targets) do |target|
    json.partial! 'basic', target: target
  end
end
