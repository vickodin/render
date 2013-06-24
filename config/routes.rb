Render::Application.routes.draw do
  constraints(Subdomain) do
    match '/'   => 'render#index'
    scope :format => true, :constraints => { :format => 'js' } do
      match '/*javascript' => 'render#javascript'
    end
    scope :format => true, :constraints => { :format => 'css' } do
      match '/*stylesheet' => 'render#stylesheet'
    end
    match '/*page' => 'render#show'
  end
end
