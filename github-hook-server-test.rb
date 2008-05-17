require 'net/http'

payload = %Q{{ 
  "before": "5aef35982fb2d34e9d9d4502f6ede1072793222d",
  "repository": {
    "url": "http://github.com/cliffrowley/test_repo",
    "name": "test_repo",
    "owner": {
      "email": "someone@somewhere.com",
      "name": "cliffrowley" 
    }
  },
  "commits": {
    "41a212ee83ca127e3c8cf465891ab7216a705f59": {
      "url": "http://github.com/cliffrowley/test_repo/commit/41a212ee83ca127e3c8cf465891ab7216a705f59",
      "author": {
        "email": "someone@somewhere.com",
        "name": "Cliff Rowley" 
      },
      "message": "Test one",
      "timestamp": "2008-02-15T14:57:17-08:00" 
    },
    "de8251ff97ee194a289832576287d6f8ad74e3d0": {
      "url": "http://github.com/cliffrowley/test_repo/commit/de8251ff97ee194a289832576287d6f8ad74e3d0",
      "author": {
        "email": "someone@somewhere.com",
        "name": "Cliff Rowley" 
      },
      "message": "Test two",
      "timestamp": "2008-02-15T14:36:34-08:00" 
    }
  },
  "after": "de8251ff97ee194a289832576287d6f8ad74e3d0" 
}}

url = URI.parse('http://localhost:4567/')
req = Net::HTTP::Post.new(url.path)
req.set_form_data({'payload' => payload})
res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
puts res
