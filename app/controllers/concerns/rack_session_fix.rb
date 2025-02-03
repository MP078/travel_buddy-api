module RackSessionFix
    extend ActiveSupport::Concern
    class FakeRackSession < Hash
            def destroy
            end

            def enabled?
                  false
            end
    end
    included do
        before_action :set_fix_rack_session_for_devise
      private
      def set_fix_rack_session_for_devise
                request.env["rack.session"] = FakeRackSession.new
      end
    end
end
