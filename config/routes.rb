Rails.application.routes.draw do

    # mount Grack::AuthSpawner, at: '/git'

    require 'grack'
    require 'grack_auth'
    mount Grack::Bundle.new({
                                git_path: APP_CONFIG['git_app'],
                                project_root: APP_CONFIG['git_repositories_root'],
                                upload_pack: 'true',
                                receive_pack: 'true'
                            }), at: '/git'


    root :to => 'view#index'
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq', via: [:get, :post, :put]

    namespace :api do

        post 'login' => 'login#login'
        post 'verify_student_access_token' => 'login#verify_student_access_token'
        post 'verify_admin_access_token' => 'login#verify_admin_access_token'
        post 'reset_password' => 'login#reset_password'
        post 'reset_password_by_token' => 'login#reset_password_by_token'
        post 'forgot_password' => 'login#forgot_password'

        post 'create_group' => 'group#create'
        post 'create_course_students' => 'admin#create_course_students'
        post 'add_teaching_assistant' => 'admin#add_teaching_assistant'

        get 'course/:course_id/students/list_without_group' => 'student#list_without_group'

        get 'course/:course_id/students/all' => 'student#all'
        get 'student/my_info' => 'student#my_info'
        post 'group/create' => 'group#create'
        post 'group/destroy' => 'group#destroy'
        get 'group/show' => 'group#show'
        get 'course/:course_id/group/all' => 'group#all'

        post 'project/create' => 'project#create'
        post 'project/destroy' => 'project#destroy'
        post 'project/edit' => 'project#edit'
        get 'project/all' => 'project#all'
        get 'project/show' => 'project#show'

        get 'project/:project_id/timelog/all' => 'timelog#all'
        post 'timelog/:timelog_id/edit' => 'timelog#edit'
        post 'timelog/:timelog_id/upload_image' => 'timelog#upload_image'
        post 'course/:course_id/timelog/create' => 'timelog#create'
        post 'timelog/:timelog_id/edit_acceptance' => 'timelog#edit_acceptance'

        get 'course/all' => 'course#all'
        get 'course/:course_id/teaching_assistants/all' => 'course#list_teaching_assistants'

        get 'teaching_assistant/all' => 'teaching_assistant#all'
        post 'teaching_assistant/add_student' => 'teaching_assistant#add_student'
        post 'teaching_assistant/students/:student_id/remove' => 'teaching_assistant#remove_student'

        post 'project/score/create' => 'score#create'
        get 'project/:project_id/no/:no/score/all' => 'score#all'
        post 'score/:score_id/destroy' => 'score#destroy'

        get 'charts/test' => 'charts#test'
        get 'charts/commits' => 'charts#commits'
        get 'charts/line_of_code' => 'charts#line_of_code'
        get 'charts/timelog' => 'charts#timelog'

        get 'notification/get_logs' => 'notification#get_logs'

        post 'homework/add' => 'homework#add'
        post 'homework/hand_in_homework' => 'homework#hand_in_homework'
        post 'homework/cancel_hand_in_homework' => 'homework#cancel_hand_in_homework'
        get 'course/:course_id/homeworks/all' => 'homework#all'

        post 'time_cost/add' => 'time_cost#add'
        post 'time_cost/:time_cost_id/destroy' => 'time_cost#destroy'
        get '/timelog/:timelog_id/time_cost/all' => 'time_cost#all'

        post 'roll_call/add' => 'roll_call#add'
        post 'roll_call/destroy' => 'roll_call#destroy'

        get 'course/:course_id/roll_call/all' => 'roll_call#all'
    end
    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    # You can have the root of your site routed with "root"
    # root 'welcome#index'

    # Example of regular route:
    #   get 'products/:id' => 'catalog#view'

    # Example of named route that can be invoked with purchase_url(id: product.id)
    #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

    # Example resource route (maps HTTP verbs to controller actions automatically):
    #   resources :products

    # Example resource route with options:
    #   resources :products do
    #     member do
    #       get 'short'
    #       post 'toggle'
    #     end
    #
    #     collection do
    #       get 'sold'
    #     end
    #   end

    # Example resource route with sub-resources:
    #   resources :products do
    #     resources :comments, :sales
    #     resource :seller
    #   end

    # Example resource route with more complex sub-resources:
    #   resources :products do
    #     resources :comments
    #     resources :sales do
    #       get 'recent', on: :collection
    #     end
    #   end

    # Example resource route with concerns:
    #   concern :toggleable do
    #     post 'toggle'
    #   end
    #   resources :posts, concerns: :toggleable
    #   resources :photos, concerns: :toggleable

    # Example resource route within a namespace:
    #   namespace :admin do
    #     # Directs /admin/products/* to Admin::ProductsController
    #     # (app/controllers/admin/products_controller.rb)
    #     resources :products
    #   end
end
