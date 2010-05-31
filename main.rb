require 'rubygems'
require 'sinatra'

class Person
  def initialize name,age
    @name = name
    @age = age
  end
  attr_reader :name,:age
end

get '/' do
  @person = Person.new('Bob',23)
  @people = [Person.new('Bart',10),Person.new('Lisa',12),Person.new('Homer',42)]
  erb :home
end

helpers do

def easy_partial template
  erb template.to_sym, :layout => false
end

def int_partial(template,locals=nil)
  locals = locals.is_a?(Hash) ? locals : {template.to_sym => locals}
  template=('_' + template.to_s).to_sym
  erb(template,{:layout => false},locals)      
end

def adv_partial(template,locals=nil)
  if template.is_a?(String) || template.is_a?(Symbol)
    template=('_' + template.to_s).to_sym
  else
    locals=template
    template=template.is_a?(Array) ? ('_' + template.first.class.to_s.downcase).to_sym : ('_' + template.class.to_s.downcase).to_sym
  end
  if locals.is_a?(Hash)
    erb(template,{:layout => false},locals)      
  elsif locals
    locals=[locals] unless locals.respond_to?(:inject)
    locals.inject([]) do |output,element|
      output << erb(template,{:layout=>false},{template.to_s.delete("_").to_sym => element})
    end.join("\n")
  else 
    erb(template,{:layout => false})
  end
end

end
