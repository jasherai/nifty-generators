require File.join(File.dirname(__FILE__), "test_helper.rb")

class TestNiftyScaffoldGenerator < Test::Unit::TestCase
  include NiftyGenerators::TestHelper
  
  # Some generator-related assertions:
  #   assert_generated_file(name, &block) # block passed the file contents
  #   assert_directory_exists(name)
  #   assert_generated_class(name, &block)
  #   assert_generated_module(name, &block)
  #   assert_generated_test_for(name, &block)
  # The assert_generated_(class|module|test_for) &block is passed the body of the class/module within the file
  #   assert_has_method(body, *methods) # check that the body has a list of methods (methods with parentheses not supported yet)
  #
  # Other helper methods are:
  #   app_root_files - put this in teardown to show files generated by the test method (e.g. p app_root_files)
  #   bare_setup - place this in setup method to create the APP_ROOT folder for each test
  #   bare_teardown - place this in teardown method to destroy the TMP_ROOT or APP_ROOT folder after each test
  context "generator without name" do
    should "raise usage error" do
      assert_raise Rails::Generator::UsageError do
        run_rails_generator :nifty_scaffold
      end
    end
  end
  
  context "generator with no options" do
    rails_generator :nifty_scaffold, "line_item"
    
    should "generate model with class as camelcase name" do
      assert_generated_file "app/models/line_item.rb" do |contents|
        assert_match "class LineItem < ActiveRecord::Base", contents
      end
    end
    
    should "generate controller with class as camelcase name pluralized and no actions" do
      assert_generated_file "app/controllers/line_items_controller.rb" do |contents|
        assert_match "class LineItemsController < ApplicationController", contents
        assert_no_match(/\bdef\b/, contents)
      end
    end
    
    should_not_generate_file "app/views/line_items/index.html.erb"
  end
  
  context "generator with index action" do
    rails_generator :nifty_scaffold, "line_item", "index"
    
    should_generate_file "app/views/line_items/index.html.erb"
    
    should "generate controller with index action" do
      assert_generated_file "app/controllers/line_items_controller.rb" do |contents|
        assert_match "def index", contents
        assert_match "@line_items = LineItem.find(:all)", contents
      end
    end
  end
  
  context "generator with show action" do
    rails_generator :nifty_scaffold, "line_item", "show"
    
    should_generate_file "app/views/line_items/show.html.erb"
    
    should "generate controller with show action" do
      assert_generated_file "app/controllers/line_items_controller.rb" do |contents|
        assert_match "def show", contents
        assert_match "@line_item = LineItem.find(params[:id])", contents
      end
    end
  end
  
  context "generator with new and create actions" do
    rails_generator :nifty_scaffold, "line_item", "new", "create"
    
    should_generate_file "app/views/line_items/new.html.erb"
    
    should "generate controller with actions" do
      assert_generated_file "app/controllers/line_items_controller.rb" do |contents|
        assert_match "def new", contents
        assert_match "@line_item = LineItem.new\n", contents
        assert_match "def create", contents
        assert_match "@line_item = LineItem.new(params[:item])", contents
        assert_match "if @line_item.save", contents
        assert_match "redirect_to @line_item", contents
        assert_match "render :action => 'new'", contents
      end
    end
  end
end
