module ChefSpec
  class APIMap

    IT_DEFAULT = "%{verb}s the %{adjective} %{noun}"
    IT_CREATE_IF_MISSING = "creates the %{adjective} %{noun} if it is missing"
    IT_MODIFY = "modifies the %{adjective} %{noun}"
    IT_TOUCH = "touches the %{adjective} %{noun}"

    EXPECT_DEFAULT = "%{verb}_%{noun}"
    EXPECT_CREATE_IF_MISSING = "create_%{noun}_if_missing"

    map = {
      :cookbook_file => {
        :it => { :create_if_missing => IT_CREATE_IF_MISSING },
        :expect => { :create_if_missing => EXPECT_CREATE_IF_MISSING }
      },
      :deploy => {
        :it => { :force_deploy => "force deploys the %{adjective} %{noun}" }
      },
      :env => {
        :it => { :modify => IT_MODIFY }
      },
      :execute => {
        :it => { :run => "executes %{adjective}" }
      },
      :file => {
        :it => {
          :create_if_missing => IT_CREATE_IF_MISSING,
          :touch => IT_TOUCH
        },
        :expect => { :create_if_missing => EXPECT_CREATE_IF_MISSING }
      },
      :git => {
        :it => {
          :default => "%{verb}s the %{adjective} git repository",
          :checkout => "checks out the %{adjective} git repository"
        }
      },
      :group => {
        :it => { :modify => IT_MODIFY }
      },
      :http_request => {
        :it => {
          :default => "performs a %{verb} HTTP request to %{adjective}"
        }
      },
      :ifconfig => {
        :it => {
          :default => "%{verb}s the %{adjective} network interface using %{noun}"
        }
      },
      :registry_key => {
        :it => {
          :create_if_missing => IT_CREATE_IF_MISSING,
          :delete => "%{verb}s the %{adjective} %{noun} value"
        }
        :expect => { :create_if_missing => EXPECT_CREATE_IF_MISSING }
      },
      :remote_directory => {
        :it => { :create_if_missing => IT_CREATE_IF_MISSING },
        :expect => { :create_if_missing => EXPECT_CREATE_IF_MISSING }
      },
      :remote_file => {
        :it => {
          :create_if_missing => IT_CREATE_IF_MISSING,
          :touch => IT_TOUCH
        },
        :expect => { :create_if_missing => EXPECT_CREATE_IF_MISSING }
      },
      :subversion => {
        :it => {
          :default => "%{verb}s the %{adjective} svn repository",
          :checkout => "checks out the %{adjective} svn repository"
        }
      },
      :file => {
        :it => {
          :create_if_missing => IT_CREATE_IF_MISSING,
          :touch => IT_TOUCH
        },
        :expect => { :create_if_missing => EXPECT_CREATE_IF_MISSING }
      }
    }
  end
end
