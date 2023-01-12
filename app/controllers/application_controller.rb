class ApplicationController < ActionController::Base
  before_action :github 

  def github
    # Repo Name
    repo = GithubService.new(EndPoints.repo)
    @repo_name = RepositoryName.new(repo.data).name
    
    # Contributor Names
    contributors = GithubService.new(EndPoints.contributors)
    @contributor_names = Contributors.new(contributors.data).contributors
    
    # Commit Count 
    commits = GithubService.new(EndPoints.commits) 
    @commits_count = RepositoryCommits.new(commits.data).commits
    
    # Pull Request Count
    pulls = GithubService.new(EndPoints.pulls("closed"))
    @pr_count = RepositoryPullRequests.new(pulls.data).count
  end
end
