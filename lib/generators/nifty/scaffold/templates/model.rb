class <%= class_name %> < ActiveRecord::Base
  attr_accessible <%= model_attributes.map { |a| ":#{a.name}" }.join(", ") %>
  <%- if options.paginate? -%>
  cattr_reader :per_page
  @@per_page = 20
  <%- end -%>
end
