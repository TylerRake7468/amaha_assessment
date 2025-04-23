Rails.application.routes.draw do
  post 'customers/import', to: 'customers#import'
end