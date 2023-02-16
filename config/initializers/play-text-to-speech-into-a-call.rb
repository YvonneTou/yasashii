client = Vonage::Client.new(
  application_id: "96063012-ae83-424a-9661-caba31c197d6",
  private_key: File.read("private.key")
)

# client.voice.create(
#   to: [{
#     type: 'phone',
#     number: "818068285005"
#   }],
#   from: {
#     type: 'phone',
#     number: "818068285005"
#   },
#   ncco: [
#     {
#       'action' => 'talk',
#       'text' => 'This is a text to speech call from Vonage'
#     }
#   ]
# )
