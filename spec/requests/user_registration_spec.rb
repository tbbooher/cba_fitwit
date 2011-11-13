require File::expand_path('../../spec_helper', __FILE__)


# here is the flow
## registration/view_cart
# on this page:
#    | - can add a coupon
#    | - can pay by session
#    | - can empty cart
#    | - can join membership
#    | - can change status (vet, etc)
# ... when done verify price, proceed to health consent
## consent
# on this page:
#    | - update health history
#    | - check approvals
# ... then onto /registration/release_and_waiver_of_liability
## release_and_waiver_of_liability
#    | - must check the box to move on
## terms_of_participation
#    | - must check the box to move on
## payment/:order_id
#    | - must enter required fields
#    | - must submit payment

# seems like all views are there, let's create a skelton

describe "The user registration process" do

  it "should not allow a non-registered user to sign up" do

    #To change this template use File | Settings | File Templates.
    true.should == false
  end

  it "should not allow any users to register without agreeing to rules" do
    pending
  end

  it "should not allow any users to register without agreeing to rules" do
    pending
  end

  # only show the user future fitness camps

  # show sold out camps

  # let them empty the cart and start over

  # check approvals

end