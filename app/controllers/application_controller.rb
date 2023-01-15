class ApplicationController < ActionController::Base
  # before_action :github 

  # def github
  #   # Usernames and User Commit Totals
  #   @users = Rails.cache.fetch('users', expires_in: 5.minutes) { GithubFacade.users }
  #   # @users = GithubFacade.users
  #   # Repo Name
  #   @repo = Rails.cache.fetch('repo', expires_in: 5.minutes) { GithubFacade.repo }
  #   # @repo = GithubFacade.repo
  #   # Pull Request Count
  #   @merged_pulls = Rails.cache.fetch('merged_pulls', expires_in: 5.minutes) { GithubFacade.merged_pulls }
  #   # @merged_pulls = GithubFacade.merged_pulls 
  # end
end
