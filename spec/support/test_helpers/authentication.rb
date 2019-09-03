module TestHelpers
    module Authentication
        def login(user, password)
            visit '/login'
            fill_in 'session_email', with: user.email 
            fill_in 'session_password', with: password
            
            click_button 'Log in'
        end
    end
end