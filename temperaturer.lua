local pin = 5 -- gpio0 = 3, gpio2 = 4
local table = {}

ds18b20.setup(pin)

function connect()
    wifi.setmode(wifi.STATION)
    wifi.sta.config {ssid="OnePlus3", pwd="AccessPoint"}
    wifi.sta.connect()
    print(wifi.sta.getip())
end

function readTemp()
    ds18b20.read(
        function(ind,rom,res,temp,tdec,par)
            table["temp"] = temp
        end,{});
end

function encodeTemp()
    return sjson.encoder(table)
end

function sendTemp()
print(encodeTemp())
http.post('http://192.168.43.130:8001/api/data',
  'Content-Type: application/json\r\n',
  '{"temperature: "'+encodeTemp()+'"}',
  function(code, data)
    if (code < 0) then
      print("HTTP request failed")
    else
      print(code, data)
    end
  end)
end

connect()
sendTemp()