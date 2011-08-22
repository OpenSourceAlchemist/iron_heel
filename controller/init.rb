module IronHeel
  class Controller < Ramaze::Controller
    layout :start
    helper :xhtml, :blue_form, :paginate
    engine :ERB
  end
end

require_relative 'main'
