require 'rails'
require 'action_view'
require 'formatted_form'

module FormattedForm
  class Engine < Rails::Engine
    initializer 'helper' do |app|
      ActionView::Base.send(:include, FormattedForm::ViewHelper)
      # Remove field_with_errors div around elements with errors
      ActionView::Base.field_error_proc = proc { |input, instance| input }
    end
  end
end