class Bot
  @hash = ""
  @command = ""
  @data = ""
  
def initialize(c)
	@command = c[:"command"]
 	@data = c[:"data"]
end
  
def command()
  return @command
end

def data()
  return @data
end
  
def hash()
  return @hash
end
  
def generateHash()
	c_hash = ""
    d_hash = ""
    @command = @command.split("")
    @data = @data.split("")

    for i in @command do
      c_hash = c_hash + i.ord.to_s
    end

    for i in @data do
      d_hash = d_hash + i.ord.to_s
    end

    c_hash = scientificNotation(c_hash) if c_hash.to_s.length >= 21
    d_hash = scientificNotation(d_hash) if d_hash.to_s.length >= 21

    c_hash = sliceNum(c_hash)
    d_hash = sliceNum(d_hash)


    hash = c_hash.to_i + d_hash.to_i

    @hash = hash.to_s(16)
  end

  def sliceNum(hash)
  if hash.to_s.include?("e+") then
    hash = hash.to_s.split("e+")  #1.2222222222e+3333 -> 1.22222222, 3333
    former = hash[0].split(".") #1.222222 -> 1, 2222222
    latter = hash[1]

    hash = former[1] + latter
  end
  return hash
end 
  
  # Convert the number into scientific notation with 16 digits after "."
  # If power of e is greater than 20, get the number between "." and "e"
  # Else return the number itself
  def scientificNotation(num)
    data = "%.16e" % num
    result = (data.split("e+")[1].to_i() > 20) ? (data): (num)
    return result
  end

end

