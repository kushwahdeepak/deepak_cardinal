import React, { useState, useReducer ,useEffect} from "react";
import { Card, Col, Row, Spinner } from 'react-bootstrap'
import Button from "react-bootstrap/Button";
import Modal from 'react-bootstrap/Modal'
import Image from 'react-bootstrap/Image';
import SearchBar from '../../common/SearchBar/SearchBar'
import styles from './styles/EmployerOrganization.module.scss';
import BlankOrganizationImage from '../../../../assets/images/organizationBlankImage.png';
import profileImage from '../../../../assets/images/img_avatar.png'
import crossButton from '../../../../assets/images/icons/crossbutton.png'
import EditOrganization from "./EditOrganization";
import { makeRequest } from "../../common/RequestAssist/RequestAssist";
import { initialState, reducer, StoreCompanyContext } from '../../../stores/CompanyProfileStore'
import './styles/EmployerOrganization.scss';
import {W5text, W4text, Container} from './styles/EditOrganization.styled'
import MembersList from './MembersList';
import CreateOrganizationPage from './CreateNewOrganization'
import Tabs from 'react-bootstrap/Tabs'
import Tab from 'react-bootstrap/Tab'
import { firstCharacterCapital } from '../../../utils/index'
import Paginator from "../../common/Paginator/Paginator";
import InvitedMembersList from './InvitedMembersList';

const initialFormData = {
  organization: {
      name: '',
      industry: '',
      company_size: '',
      country: '',
      city: '',
      region: '',
      description: '',
      logo: null,
  }
}

function EmployerOrganization({currentUser, organization, members, logo_url, invitedRecruiter}) {
  const [organizationData, setOrganizationData] = useState(initialFormData)
  const [isOpen, setIsOpen] = useState(false);
  const [errorFetchingrecuiter, setErrorFetchingRecruiteer] = useState(null)
  const [recruiter, setRecruiter] = useState('')
  const [searchMember, setSearchMember] = useState('')
  const [email, setEmail] = useState('')
  const [member, setMember] = useState('')
  const [isOpenDetail, setIsOpenDetail] = useState(false);
  const [isOpenNewOrg, setIsOpenNewOrg] = useState(false);
  const [activePage, setActivePage] = useState(0)
  const [loading, setLoading] = useState(false)
  const {id, name, description, industry, min_size, max_size, city, country, region, company_size} = organization || {}
  let initialValue = { ...initialState}
  if(organization) { 
    initialValue = { ...initialValue, 
      ...{id, name, description,industry, min_size, max_size, region, city, country, logo_url: logo_url, company_size},
      ...{companySizes: [], industries: []}
    } 
  }
  
  let invitedRecruitersData = invitedRecruiter
  const [invitedRecruiters, setInvitedRecruiters] = useState([...invitedRecruitersData])
  const [state, dispatch] = useReducer(reducer, initialValue)

  const showModal = () => {
    setIsOpen(true);
  };

  const hideModal = () => {
    setIsOpen(false);
  };

  const showModalDetail = () => {
    setIsOpenDetail(true);
  };

  const hideModalDetail = () => {
    setIsOpenDetail(false);
  };

  const showModalNewOrg = () => {
    setIsOpenNewOrg(true);
  };

  const hideModalNewOrg = () => {
    setIsOpenNewOrg(false);
  };

  useEffect(() => {
    setLoading(true)
    const lookupsUrl = '/signup/lookups'
    fetch(lookupsUrl)
    .then(res => res.json())
    .then(
      (result) => {
        const {company_sizes, industries} = result
        dispatch({
          type: 'set_company_size_and_industry_types',
          value: {companySizes: [...company_sizes], industries: [...industries] }
        })
        setLoading(false)
      },
      (error) => {
        console.log(error);
        setLoading(false)
      }
    )
  }, []);
  
  const handleSearch = async () => {
    const url = '/search_recruiter'

    const formData = new FormData()
    formData.append('organization[email]', email)
    try {
        await makeRequest(url,  'post', formData,{
            contentType: 'application/json',
            loadingMessage: 'Submitting...',
            createResponseMessage: (response) => {
              return {message: response.message}
            },
        }).then((res) => {
            setSearchMember(res.data.recruiter_data)
        })    
    } catch (e) {
        console.error(e.message)
        setErrorFetchingRecruiteer(e.message)
    }
  }

  const handleSearchOrg = async () => {
    const url = '/search_member'
    const formData = new FormData()
    formData.append('member', member)
    try {
        await makeRequest(url,  'post', formData,{
            contentType: 'application/json',
            loadingMessage: 'Submitting...',
            createResponseMessage: (response) => {
                return response.message
            },
        }).then((res) => {
            setRecruiter(res.data.member_data)
        })    
    } catch (e) {
        console.error(e.message)
        setErrorFetchingRecruiteer(e.message)
    }
  }
    
  const handleRecruiterInvitation = async () =>{
      const url = `/organizations/${organization.id}/invitations`
      const formData = new FormData()
      formData.append('invitation[invited_user_id]', searchMember.id)
      formData.append('organization_id', organization.id)
      const CSRF_Token = document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute('content')

      try {
          await makeRequest(url,  'post', formData,{
              contentType: 'application/json',
              loadingMessage: 'Submitting...',
              createResponseMessage: (response) => {
                return {message: response.message}
              },
          }).then((res) => {
              invitedRecruitersData.push(res.data.invited_recruiter_details)
              setInvitedRecruiters([...invitedRecruitersData])
              setIsOpen(false);
              setRecruiter('')
          })
      } catch (e) {
          console.error(e.message)
          setErrorFetchingRecruiteer(e.message)
      }
  }

  const format_logo_url = (avatar_url) => {
    if(typeof avatar_url == "object"){
      return(URL.createObjectURL(avatar_url))
    }
    return avatar_url
  }

  const handleInviteModal = () => {
    setIsOpen(false)
    setSearchMember('')
  }

  const handleSubmit = async (value) => {
      const url = '/organizations'
      const payload = new FormData()
      payload.append('organization[name]', value.organization.name)
      payload.append(
          'organization[description]',
          value.organization.description
      )
      payload.append('organization[industry]', value.organization.industry)
      payload.append(
          'organization[company_size]',
          value.organization.companySize
      )
      payload.append('organization[country]', value.organization.country)
      payload.append('organization[region]', value.organization.region)
      payload.append('organization[city]', value.organization.city)
      if (value.organization.logo) {
          payload.append('organization[logo]', value.organization.logo)
      }
      try {
          await makeRequest(url,  'post', payload,{
              contentType: 'multipart/form-data',
              loadingMessage: 'Submitting...',
              createResponseMessage: (response) => {
                  return response.message
              },          
          })
          setIsOpenNewOrg(false) 
          setTimeout(() => {
            window.location.reload()
          }, 1000) 

      } catch (e) {
          console.error(e.message)
      }
  }

  const renderSwitch = (param) => {
    switch(param) {
      case 1:
        return '0-1';
      case 2:
        return '2-10';
      case 11:
        return '11-50';
      case 51:
        return '51-200';
      case 201:
        return '201-500';
      case 501:
        return '501-1,000';
      case 1001:
        return '1,001-5,000';
      case 5001:
        return '5,001-10,000';
      case 10001:
        return '10,001+'
      default:
        return '0';
    }
  }

    const organizationBlank = () => {
      return(
        <div>
          <div className={`${styles.profileHeading} jumbotron jumbotron-fluid`}>
            <div className="container">
            </div>
          </div>
          <div className="container">
            <div className={`${styles.profileImageSection}`}>
              <Row>
                <Col xs={12}>
                  <div  className={`${styles.NoOrganizationProfile}`}>
                    <div className={`${styles.NoLogoContent}`}>No Logo</div>
                  </div>
                </Col>
              </Row>
            </div>
          </div>
          <div className={`${styles.DisplayNoOrganaizationHeading}`}>
            You're not part of an organization yet!
          </div>
          <div className={`${styles.DisplayNoOrganizationSubHeading}`}>
            If your company already has an organization, the admin can add you to their organization.
          </div>
          <Button className={`${styles.NewOrganizationButton}`} onClick={showModalNewOrg}>
            Create New Organization
          </Button>
          <Modal show={isOpenNewOrg} onHide={hideModalNewOrg} size={"xl"} >
            <Modal.Body >
                <CreateOrganizationPage
                  formData={organizationData}
                  setFormData={setOrganizationData}
                  handleSubmit={(value) =>{
                    handleSubmit(value)
                  }}
                />
            </Modal.Body>
          </Modal>
        </div>
      )
    }

    const organizationExist = () => {
      const { logo_url, name, region, city, description,industry,company_size }= state
      const pageCount = recruiter.length > 0 ? Math.ceil(recruiter.length / 12) : Math.ceil(members.length / 12);
      return(
        <div className="candidate-view-profile-page">
          <div className={`${styles.header_image}`} style={{ height: '150px', position: 'relative'}}>
            <div className="container" >
              <div className="profile-pic">
                {loading ? (
                  <div className={`${styles.spinnerStyles}`}>
                    <Spinner animation="border" role="status">
                        <span className="sr-only">Loading...</span>
                    </Spinner>
                  </div>
                  ) : (
                  <Image
                    src={logo_url ? format_logo_url(logo_url) : BlankOrganizationImage}
                    className={`${styles.profileImage}`}
                  />
                )}
              </div>
            </div>
          </div>
          <div className="container">
          <Row className="mt-lg-4">
            <Col xs={2} >
            </Col>
            <Container aItems='center' style={{marginRight:'20px',maxWidth:'270px'}}>
              <W5text size="28px" color="#1D2447">{name}</W5text>
            </Container>
            <Container aItems='center' style={{marginTop:'0px', marginRight:'20px',maxWidth:'200px'}}>
              <W4text size="17px" color="#1D2447">{city ? city : ''}{region ? ',' : ''} {region ? region : ''}</W4text>
            </Container>
            <Container aItems='center'  style={{marginRight:'20px'}}>
              <Button className={`${styles.DesignationButton}`}>
                {currentUser.role? firstCharacterCapital(currentUser.role) : ''}
              </Button>
            </Container>
              <div style={{flexGrow:1}}>
              </div>
             
            <Container  aItems='center' className="text-right">
              <Button className={`${styles.editOrgaDetailButton}`} onClick={showModalDetail}>
                 Edit Organization Details
              </Button>
              <EditOrganization
                organization={organization}
                members={members}
                isOpenDetail={isOpenDetail}
                hideModalDetail={hideModalDetail}
                format_logo_url={format_logo_url}
                renderSwitch={renderSwitch}
              />
            </Container>
          </Row>
          </div>
          <div className="container">
          <Tabs
                defaultActiveKey="description"
                className="organization-activity-tabs"
          >
            <Tab eventKey="description" title="About">
            <Col xs={12} sm={9}>              
                    <div className={`${styles.organizationDetailsHeadline}`}>
                      Description
                    </div>
                    <div className={`${styles.organizationDetailsDescription}`}>
                      {description}
                    </div>
                
                    <div className={`${styles.organizationDetailsHeadline}`}>
                      Industry
                    </div>
                    <div className={`${styles.organizationDetailsIndustry}`}>
                      {industry ? industry : ''}
                    </div>
                  
                    <div className={`${styles.organizationDetailsHeadline}`}>
                      Company Size
                    </div>
                    <div className={`${styles.organizationDetailsCompanySize}`}>
                      {company_size === 0 ? '0-1 Employee' : company_size !== 0 ? `${renderSwitch(company_size)} Employees` : ''}
                    </div>
                  </Col>
            </Tab>
            <Tab eventKey="members" title="Members">
            <Col xs={12} sm={12}>
                      <Row>
                        <Col xs={6} sm={6} md={4}>
                          <div className={`${styles.OrganizationMembers}`}>
                            Members
                          </div>
                        </Col>
                        <Col xs={6} sm={6} md={4}>
                          <Button className={`${styles.InviteMembersButton}`} onClick={showModal}>
                              Invite Members
                          </Button>
                        </Col>
                        <Col xs={12} sm={12} md={4} className={styles.organizationMemberSearch}>
                          <SearchBar
                            placeholder="Search member list"
                            hideButton = {false}
                            onChange={(e) => setMember(e.target.value)}
                            onEnterPressed={() => {
                                handleSearchOrg()
                            }}
                          />
                        </Col>
                      </Row>
                    <Col xs={12}>
                      <Row className={`${styles.RowStyles}`}>
                        
                        <Modal size='sm' show={isOpen} onHide={hideModal} animation={false}>
                          <Modal.Body className={`${styles.InviteMembersModalStyles}`}>
                            <div className={`${styles.InviteModalHeading}`}>
                              Invite Members
                            </div>
                            <button
                              style={{border:'none', background: 'white', position: 'relative', float: 'right',bottom: '-18px', right: '11px', outline: 'none'}}
                              className='crossbutton' onClick={handleInviteModal}
                            >
                              <img
                                src={crossButton}
                                style={{  height: '30px',
                                          position: 'relative',
                                          float: 'right',
                                          left: '0px',
                                          bottom: '0px'
                                        }}
                              />
                            </button>
                            <div className={`${styles.SearchBarInviteMember}`}>
                              <SearchBar
                                placeholder="Search..."
                                hideButton = {false}
                                onChange={(e) => setEmail(e.target.value)}
                                onEnterPressed={() => {
                                    handleSearch()
                                }}
                              /> 
                            </div>
                            { searchMember != '' ? recrutierExist() : recrutierBlank() }
                          </Modal.Body>
                        </Modal>
                        
                      </Row>
                    </Col>
                    <Row xs={12}>
                      <MembersList
                        members={recruiter.length > 0 ?
                          activePage > 0 ?
                          recruiter.slice((activePage) * 12,(activePage+1) * 12) :
                          recruiter.slice(activePage,(activePage+1) * 12) :
                          activePage > 0 ?
                          members.slice((activePage) * 12,(activePage+1) * 12) :
                          members.slice(activePage,(activePage+1) * 12)}
                      />
                    </Row>
                    <Row>
                        <Col xs={6} sm={6} md={4}>
                          <div className={`${styles.OrganizationMembers}`}>
                          Invited Members
                          </div>
                        </Col>
                    </Row>
                    <Row xs={12}>
                      <InvitedMembersList
                        invitedRecruiters={invitedRecruiters}
                        organization={organization}
                      />
                    </Row>
                    <div
                    className="d-flex justify-content-center"
                    style={{ marginTop: 'auto' }}
                    >
                      <Paginator 
                        activePage={activePage}
                        setActivePage={setActivePage}
                        pageCount={ pageCount }
                        pageWindowSize={5}
                        showGoToField={false}
                      />
                      </div>
                  </Col>
            </Tab>
          </Tabs>
          </div>
        </div>
      )
    }

    const recrutierExist = () => {
      return(
        <Card>
          <Card.Body>
            <div className='row'>
              <img className={styles.recruiterProfileImage} src={searchMember && searchMember.image_url ? format_logo_url(searchMember && searchMember.image_url) : profileImage} />
                <div className={styles.cardBody + 'container'} >
                  <h5>{searchMember && (searchMember?.first_name + ' ' +  searchMember?.last_name) }</h5>
                  <h5 style={{fontSize: '16px'}}>{searchMember && searchMember?.role }</h5>
                </div>
              <div>
                <Button 
                  className={styles.inviteButton}
                  onClick={()=>{
                    handleRecruiterInvitation()
                  }}
                >
                  Invite
                </Button>
              </div>
            </div>
          </Card.Body>
        </Card>
      )
    }

    const recrutierBlank = () => {
      return(
        <div>
          <Card>
            <Card.Body>
            <h6 className={styles.SearchByNameInviteMember}>Search by email to invite someone to your organization</h6>
            </Card.Body>
          </Card>
        </div>
      )
    }

  return (
    <>
      <StoreCompanyContext.Provider value={{ state, dispatch }}>
        {(organization === null) ? organizationBlank() : organizationExist() }
      </StoreCompanyContext.Provider>
    </>
  );
}

export default EmployerOrganization;
