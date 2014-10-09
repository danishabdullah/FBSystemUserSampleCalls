#! /bin/bash
# This bash script is written with httpie in mind which is a bash replacement
# business_admin_user_and_ads_api_app_pair_token:= It is the token of the business admin user issued to the app being added
# Claim the app for your business (app should be whitelisted for ads api access)
http POST \
app_id==123456789 \
access_type==OWNER \
access_token==<business_admin_user_and_ads_api_app_pair_token> \
https://graph.facebook.com/<business_id>/apps

# Create Admin System User
http POST \
name==Ad Server \
role==ADMIN_SYSTEM_USER \
access_token==<business_admin_user_and_ads_api_app_pair_token> \
https://graph.facebook.com/<business_id>/system_users

# Tos the app for the admin system user
http POST \
business_app==1243595696 \
access_token==<business_admin_user_and_ads_api_app_pair_token> \
https://graph.facebook.com/<admin_system_user_id>/applications

# Genereate admin system user token (proof should be calculated for the caller app not the app in parameter)
http POST \
business_app==1243595696 \
scope==ads_management,manage_pages \
appsecret_proof==<hmac_of_appsecret_token_of_calling_app> \
access_token==<business_admin_user_and_ads_api_app_pair_token> \
https://graph.facebook.com/<admin_system_user_id>/ads_access_token

# Create an adaccount
http POST https://graph.facebook.com/<business_id>/partneradaccount \
name==MyAdAccount \
currency==USD \
timezone_id==1 \
end_advertiser==my company \
media_agency==123456 \
partner==NONE \
access_token==<admin_system_user_token> 


# Create Regular System User
http POST https://graph.facebook.com/<business_id>/system_users \
name==Ad Server \
role==SYSTEM_USER \
access_token==<admin_system_user_token> 

# Tos the app for the regular system user
http POST  https://graph.facebook.com/<regular_system_user_id>/applications \
business_app==1243595696 \
access_token==<admin_system_user_token> 

# Genereate regular system user token (proof should be calculated for the caller app not the app in parameter)
http POST https://graph.facebook.com/<regular_system_user_id>/ads_access_token \
business_app==1243595696 \
scope==ads_management,manage_pages \
appsecret_proof==<hmac_of_appsecret_token_of_calling_app> \
access_token==<admin_system_user_token> 

# Assign permission to adaccount for system user
http POST https://graph.facebook.com/<act_adaccount_id>/userpermissions \
user==<regular_system_user_id> \
role==ADMIN \
business==<business_id> \
access_token==<admin_system_user_token> 

# Make call on the adaccount
http GET  https://graph.facebook.com/adaccount_id/stats \
access_token==<regular_system_user_token> 
