# WORDS HISTOGRAM API

This API is a tool to come out the most used words in a file text, given to you a histogram structure. The ouput is returned in JSON format 

# Requirements

* Terminal or command prompt or an API tester like Postman https://makolyte.com/how-to-upload-a-file-with-postman/ to send files through HTTP requests
* You only can use .txt files
* Plain text should be filled with at least two words

# Usage

* Send the file passing **'file'** as key word to this endpoint with POST request:
> https://histogram-words-api/api/v1/histogram_words

It returns a json with the **id** and **data** histogram
```
{'id': '1', 'data': [{"word"=>"lumu", "count"=>6}, {"word"=>"illuminates", "count"=>3}, {"word"=>"attacks", "count"=>2}, {"word"=>"and", "count"=>2}, {"word"=>"adversaries", "count"=>2}, {"word"=>"all", "count"=>1}]}
```

* You can also check it out specific record passing by GET request:
> https://histogram-words-api/api/v1/histogram_words/:id

It just returns the **data**
```
{[{"word"=>"lumu", "count"=>6}, {"word"=>"illuminates", "count"=>3}, {"word"=>"attacks", "count"=>2}, {"word"=>"and", "count"=>2}, {"word"=>"adversaries", "count"=>2}, {"word"=>"all", "count"=>1}]}
```

# Error handling
* If file requirments are not acomplished you will get (HTTP) 422 Unprocessable entity
* For records not saved you will get (HTTP) 404 Not Found
