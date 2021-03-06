# ============================================================================
# DEXTERITY ROBOT TESTS
# ============================================================================
#
# Run this robot test stand-alone:
#
#  $ bin/test -s edi.checkapp -t test_checkliste.robot --all
#
# Run this robot test with robot server (which is faster):
#
# 1) Start robot server:
#
# $ bin/robot-server --reload-path src edi.checkapp.testing.EDI_CHECKAPP_ACCEPTANCE_TESTING
#
# 2) Run robot tests:
#
# $ bin/robot /src/edi/checkapp/tests/robot/test_checkliste.robot
#
# See the http://docs.plone.org for further details (search for robot
# framework).
#
# ============================================================================

*** Settings *****************************************************************

Resource  plone/app/robotframework/selenium.robot
Resource  plone/app/robotframework/keywords.robot

Library  Remote  ${PLONE_URL}/RobotRemote

Test Setup  Open test browser
Test Teardown  Close all browsers


*** Test Cases ***************************************************************

Scenario: As a site administrator I can add a Checkliste
  Given a logged-in site administrator
    and an add Antwort form
   When I type 'My Checkliste' into the title field
    and I submit the form
   Then a Checkliste with the title 'My Checkliste' has been created

Scenario: As a site administrator I can view a Checkliste
  Given a logged-in site administrator
    and a Checkliste 'My Checkliste'
   When I go to the Checkliste view
   Then I can see the Checkliste title 'My Checkliste'


*** Keywords *****************************************************************

# --- Given ------------------------------------------------------------------

a logged-in site administrator
  Enable autologin as  Site Administrator

an add Antwort form
  Go To  ${PLONE_URL}/++add++Antwort

a Checkliste 'My Checkliste'
  Create content  type=Antwort  id=my-checkliste  title=My Checkliste

# --- WHEN -------------------------------------------------------------------

I type '${title}' into the title field
  Input Text  name=form.widgets.IBasic.title  ${title}

I submit the form
  Click Button  Save

I go to the Checkliste view
  Go To  ${PLONE_URL}/my-checkliste
  Wait until page contains  Site Map


# --- THEN -------------------------------------------------------------------

a Checkliste with the title '${title}' has been created
  Wait until page contains  Site Map
  Page should contain  ${title}
  Page should contain  Item created

I can see the Checkliste title '${title}'
  Wait until page contains  Site Map
  Page should contain  ${title}
