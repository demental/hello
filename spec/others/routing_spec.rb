require 'spec_helper'


module Hello
  describe 'Routing' do

    before do
      # @route_set  = ActionDispatch::Routing::RouteSet.new
      # @routes = @route_set.router.routes
      # @router = @route_set.router
      # @formatter = @route_set.formatter
      # @mapper = ActionDispatch::Routing::Mapper.new @route_set

      @route_set  = Rails.application.routes
      @routes = @route_set.router.routes
      @router = @route_set.router
      @formatter = @route_set.formatter
      @mapper = ActionDispatch::Routing::Mapper.new @route_set
    end

    describe 'signed in' do
      let(:signed_in) { true }
      it('a') { expect(get_status_for('/routing/foo')).to       eq(200) }
      it('auth gets 200')     { expect(get_status_for('/routing/auth')).to                 eq(200) }
      it('present gets 200')  { expect(get_status_for('/routing/current_user_present')).to eq(200) }
      it('not auth gets 404') { expect(get_status_for('/routing/not_auth')).to             eq(404) }
      it('blank gets 404')    { expect(get_status_for('/routing/current_user_blank')).to   eq(404) }
    end

    describe 'signed out' do
      let(:signed_in) { false }
      it('a') { expect(get_status_for('/routing/foo')).to       eq(200) }
      it('auth gets 404')     { expect(get_status_for('/routing/auth')).to                 eq(404) }
      it('present gets 404')  { expect(get_status_for('/routing/current_user_present')).to eq(404) }
      it('not auth gets 200') { expect(get_status_for('/routing/not_auth')).to             eq(200) }
      it('blank gets 200')    { expect(get_status_for('/routing/current_user_blank')).to   eq(200) }
    end

    def get_status_for(url)
      @router.serve(rails_env({ 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => url })).first
    end

    def rails_env env
      klass = ActionDispatch::Request
      r = klass.new(rack_env(env))
      r.env['hello'] = Hello::Manager::StatelessRequestManager.new(r)
      if @signed_in
        r.env['HTTP_ACCESS_TOKEN'] = create(:valid_access).token
      end
      r
    end

    def rack_env env
      {
        "rack.version"      => [1, 1],
        "rack.input"        => StringIO.new,
        "rack.errors"       => StringIO.new,
        "rack.multithread"  => true,
        "rack.multiprocess" => true,
        "rack.run_once"     => false,
        "REQUEST_METHOD"    => "GET",
        "SERVER_NAME"       => "example.org",
        "SERVER_PORT"       => "80",
        "QUERY_STRING"      => "",
        "PATH_INFO"         => "/content",
        "rack.url_scheme"   => "http",
        "HTTPS"             => "off",
        "SCRIPT_NAME"       => "",
        "CONTENT_LENGTH"    => "0"
      }.merge env
    end

  end
end
