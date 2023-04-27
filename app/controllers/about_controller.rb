class AboutController < ApplicationController
  skip_before_action :authenticate_user!
  after_action :verify_authorized, except: [:show]

  def show
    @members = User.first(4)
    @contact_info = contact_info
  end

  private

  def contact_info
    {
      yvonne: {
        role: 'Lead Developer',
        gmail: 'tou.yvonne@gmail.com',
        github: 'https://github.com/YvonneTou/',
        linkedin: 'https://www.linkedin.com/in/touyvonne/'
      },

      tanner: {
        role: 'Backend Lead',
        gmail: 'tanner.ray.maxwell@gmail.com',
        github: 'https://github.com/tmxds',
        linkedin: 'https://www.linkedin.com/in/tanner-maxwell-18052088'
      },

      sarah: {
        role: 'Frontend Lead',
        gmail: 's.rollins751@gmail.com',
        github: 'https://github.com/srollins01',
        linkedin: 'https://www.linkedin.com/in/sarah-rollins-sr/'
      },

      danielle: {
        role: 'Project Manager',
        gmail: 'danielle.a.smart@gmail.com',
        github: 'https://github.com/sumaatsu',
        linkedin: 'https://www.linkedin.com/in/danielle-matsumoto/'
      }
    }
  end
end
