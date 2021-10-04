import React, { useEffect, useState,Fragment} from 'react'
import { Container, Col, Image } from 'react-bootstrap'
import Row from 'react-bootstrap/Row'
import axios from 'axios'
import Spinner from 'react-bootstrap/Spinner'
import Alert from 'react-bootstrap/Alert'

import './styles/MyConnectionPage.scss'
import GithubIcon from '../../../../assets/images/icons/github-icon.svg'
import LinkedinIcon from '../../../../assets/images/icons/linkedin-icon.svg'
import PencilIcon from '../../../../assets/images/icons/pencil-icon-v2.svg'
import CandidateTwoImage from '../../../../assets/images/img_avatar.png'
import ReceivedRequestConnectionPage from './ReceivedRequestConnectionPage'
import ApprovedConnectionPage from './ApprovedConnectionPage'
import {
    Wrapper, Box, Tab, TabContainer, W4text,
    PainatorContainer, W5text, W8text, InfoContainer, Card
} from './styles/MyConnection.styled'
import Paginator from '../../common/Paginator/Paginator'

function MyConnectionIndex({ current_user, avatar_url }) {
    const { id, linkedin_profile_url, location, job_title, github_url, name } =
        current_user
    const [sendContactsActivePage, setSendContactsActivePage] = useState(0)
    const [receivedContactsActivePage, setReceivedContactsActivePage] =
        useState(0)
    const [approvedContactsActivePage, setApprovedContactsActivePage] =
        useState(0)
    const [sendContactRequests, setSendContactRequests] = useState([])
    const [receivedContactRequests, setReceivedContactRequests] = useState([])
    const [approvedContactRequests, setApprovedContactRequests] = useState([])
    const [sendRequestTotalCount, setSendRequestTotalCount] = useState(0)
    const [receivedRequestTotalCount, setReceivedRequestTotalCount] =
        useState(0)
    const [approvedRequestTotalCount, setApprovedRequestTotalCount] =
        useState(0)
    const [sendContactsTotalPage, setSendContactsTotalPage] = useState(0)
    const [receivedContactsTotalPage, setReceivedContactsTotalPage] =
        useState(0)
    const [acceptedContactsTotalPage, setAcceptedContactsTotalPage] =
        useState(0)

    const [errorFetchingContent, setErrorFetchingContent] = useState(null)
    const [loading, setLoading] = useState(false)
    const [tab, setTab] = useState('sent')

    const getMyConnections = (
        sendPageNum,
        receivedPageNum,
        acceptedPageNum
    ) => {
        axios
            .get(
                `/my_connections.json?sent_contacts=true&sent_contacts_page=${sendPageNum}&received_contacts_page=${receivedPageNum}&accepted_contacts_page=${acceptedPageNum}`
            )
            .then((res) => {
                setSendContactRequests(res.data.send_contact_requests)
                setReceivedContactRequests(res.data.received_contact_requests)
                setApprovedContactRequests(res.data.accepted_contact_requests)
                setSendRequestTotalCount(res.data.send_contact_total_count)
                setReceivedRequestTotalCount(
                    res.data.received_contact_total_count
                )
                setApprovedRequestTotalCount(
                    res.data.accepted_contact_total_count
                )
                setSendContactsTotalPage(res.data.send_contact_total_page)
                setReceivedContactsTotalPage(
                    res.data.received_contact_total_page
                )
                setAcceptedContactsTotalPage(
                    res.data.accepted_contact_total_page
                )
                setLoading(false)
            })
            .catch((error) => {
                setErrorFetchingContent(error.message)
                setLoading(false)
            })
    }

    useEffect(() => {
        if (window.cloudsponge) {
            cloudsponge.init({
                sources: ['gmail'],

                afterSubmitContacts: function (contacts, source, owner) {
                    var token = document.querySelector(
                        'meta[name="csrf-token"]'
                    ).content

                    axios
                        .post('/my_connections.json', {
                            authenticity_token: token,
                            contacts: contacts,
                            source: source,
                            owner: owner,
                        })
                        .then((res) => {
                            setSendContactRequests(
                                res.data.send_contact_requests
                            )
                            setSendRequestTotalCount(
                                res.data.send_contact_total_count
                            )
                            setSendContactsTotalPage(
                                res.data.send_contact_total_page
                            )
                        })
                },
            })
        }
    }, [])

    useEffect(() => {
        setLoading(true)
        getMyConnections(
            sendContactsActivePage + 1,
            receivedContactsActivePage,
            approvedContactsActivePage
        )
    }, [sendContactsActivePage])

    useEffect(() => {
        setLoading(true)
        getMyConnections(
            sendContactsActivePage,
            receivedContactsActivePage + 1,
            approvedContactsActivePage
        )
    }, [receivedContactsActivePage])

    useEffect(() => {
        setLoading(true)
        getMyConnections(
            sendContactsActivePage,
            receivedContactsActivePage,
            approvedContactsActivePage + 1
        )
    }, [approvedContactsActivePage])

    function isEmpty(value) {
        return value && value.length
    }

    // handel broken image url
    function handelBrokenUrl(event) {
      if(event.target.naturalHeight == 0)
        event.target.src = CandidateTwoImage
    }

    return (
        <Container className="mt-5 mb-5">
            <Row>
                <Col md={2} lg={2} sm={2}>
                    <div className="user-img">
                        <img
                            alt="Blank Profile"
                            className="rounded-circle circle-img-header"
                            src={avatar_url || CandidateTwoImage}
                            onError = {(event) => {handelBrokenUrl(event)}}
                        />
                    </div>
                </Col>
                <Col md={4} lg={4} sm={4}>
                    <Col sm={10} className="user-name">
                        <InfoContainer>
                         <W8text color="#435AD4" size="28px" className="mb-1"> {name} </W8text>
                         <W5text color="#435AD4" size="12px" className="mb-1"> {job_title} </W5text>
                         <W5text color="#435AD4" size="12px" className="mb-1"> {location} </W5text>
                        </InfoContainer>
                        <div className="d-flex" style={{flexDirection:'row'}}>
                            {isEmpty(linkedin_profile_url) && (
                                <Card style={{width:'max-content'}}  className="mb-1">
                                
                                <a href={linkedin_profile_url}><Image className="mr-3" src={LinkedinIcon} /></a>
                                </Card>
                            )}
                            {isEmpty(github_url) && 
                            <Card style={{width:'max-content'}} className="mb-1">
                           
                            <a  href={github_url}> <Image className="mr-3" src={GithubIcon} /></a>
                            </Card>
                            }
                        </div>
                    </Col>
                </Col>
                <Col md={6} lg={6} sm={6}>
                    <div className="text-right invite-details">
                        <button
                            type="button"
                            className="btn cloudsponge-launch btn-primary mb-2"
                        >
                            Invite Contacts
                        </button>
                        <br />
                    </div>
                    <div className="text-right add-section">
                        <a
                            href={`users/profile/${id}`}
                            style={{ fontSize: '14px' }}
                        >
                            Edit Profile <Image src={PencilIcon} />
                        </a>
                    </div>
                </Col>
            </Row>
            <div className="conatiner">
                <h3 className="myConnection"> My Connections </h3>
                <TabContainer>
                    <Tab onClick={() => setTab('sent')}>
                        <W4text
                            color={tab === 'sent' ? 'black' : '#4C68FF'}
                            size="14px"
                        >
                            Sent({sendRequestTotalCount})
                        </W4text>
                    </Tab>
                    <Tab onClick={() => setTab('recevied')}>
                        <W4text
                            color={tab === 'recevied' ? 'black' : '#4C68FF'}
                            size="14px"
                        >
                            Received({receivedRequestTotalCount})
                        </W4text>
                    </Tab>
                    <Tab onClick={() => setTab('approved')}>
                        <W4text
                            color={tab === 'approved' ? 'black' : '#4C68FF'}
                            size="14px"
                        >
                            Approved({approvedRequestTotalCount})
                        </W4text>
                    </Tab>
                </TabContainer>
                {
                
                     (loading || !!(errorFetchingContent) ) ? (
                      loading &&
                       (<div className="d-flex justify-content-center">
                         <Spinner animation="border" role="status">
                            <span className="sr-only">Loading...</span>
                         </Spinner>
                       </div>) ||
                     errorFetchingContent && 
                      (<Alert variant="danger" onClose={() => setErrorFetchingContent(null)} dismissible>
                      {errorFetchingContent}
                    </Alert>)):
                    
                
                <Wrapper>
                    
                    <Box display={tab === 'recevied' ? 'flex' : 'none'}>
                        <ReceivedRequestConnectionPage
                            contacts={receivedContactRequests}
                            handleReceivedRequestTotalCount={
                                setReceivedRequestTotalCount
                            }
                            handleReceivedContactRequests={
                                setReceivedContactRequests
                            }
                            handleReceivedContactsTotalPage={
                                setReceivedContactsTotalPage
                            }
                            handleApprovedContactRequests={
                                setApprovedContactRequests
                            }
                            handleApprovedRequestTotalCoun={
                                setApprovedRequestTotalCount
                            }
                            handleAcceptedContactsTotalPage={
                                setAcceptedContactsTotalPage
                            }
                            handleErrorFetchingContent={setErrorFetchingContent}
                        />
                        {(receivedContactsTotalPage > 1) && <PainatorContainer>
                        <Paginator
                            pageCount={receivedContactsTotalPage}
                            activePage={receivedContactsActivePage}
                            setActivePage={setReceivedContactsActivePage}
                            pageWindowSize={10}
                        />
                        </PainatorContainer>}
                    </Box>
                    <Box display={tab === 'approved' ? 'flex' : 'none'}>
                        <ApprovedConnectionPage
                            contacts={approvedContactRequests}
                        />
                        {(acceptedContactsTotalPage > 1) && <PainatorContainer>
                        <Paginator
                            pageCount={acceptedContactsTotalPage}
                            activePage={approvedContactsActivePage}
                            setActivePage={setApprovedContactsActivePage}
                            pageWindowSize={10}
                        />
                        </PainatorContainer>}
                    </Box>
                    <Box display={tab === 'sent' ? 'flex' : 'none'}>

                        {sendContactRequests.length === 0 ? (
                            <div className="card-body d-flex justify-content-center">
                                <W4text color="#4C68FF" size="14px">
                                    Invite Contacts
                                </W4text>
                            </div>
                        ) : (
                            <Fragment>
                                {sendContactRequests.map((contact, index) => (
                                    <Fragment key={index}>
                                        <div className="cord-container">
                                            <div className="card contacts-card">
                                                <div className="card-body">
                                                    <Row className='ml-0 mr-0'> 
                                                      
                                                    <div>
                                                     <img
                                                       height="80px"
                                                       width="80px"
                                                       alt="Blank Profile"
                                                       className="rounded-circle send-connection-img"
                                                       src="https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                                                     />
                                                     </div> 
                                                     <InfoContainer className="ml-3" jContent="center">
                                                        <W8text color="#465189" size="12px" className="mb-1"> {!!contact.full_name? contact.full_name: contact.email}</W8text>
                                                        <W5text color="#465189" size="10px" className="mb-1"> {contact.job_title} </W5text>
                                                        <W5text color="#465189" size="10px" className="mb-1"> {contact.full_address} </W5text>
                                                     </InfoContainer>
                                                        <div style={{flexGrow:1}}/>
                                                            <div className="msg-btn">
                                                                <button
                                                                    style={{
                                                                        fontSize:
                                                                            '14px',
                                                                    }}
                                                                    type="button"
                                                                    className="btn btn-primary mr-5"
                                                                >
                                                                    Message
                                                                </button>
                                                            </div>
                                                
                                                       
                                                    </Row>
                                                </div>
                                            </div>
                                        </div>
                                    </Fragment>
                                ))}
                            </Fragment>
                        )}
                        {sendContactsTotalPage > 1 && (
                            <PainatorContainer>
                                <Paginator
                                    pageCount={sendContactsTotalPage}
                                    activePage={sendContactsActivePage}
                                    setActivePage={setSendContactsActivePage}
                                    pageWindowSize={10}
                                />
                            </PainatorContainer>
                        )}
                    </Box>
                </Wrapper>
                }
            </div>
        </Container>
    )
}

function noDataAvailableMessage(message) {
    return (
        <div className="row empty-connections-row">
            <div className="card empty-connections-card">
                <p className="text-info"> {message} </p>
            </div>
        </div>
    )
}

export default MyConnectionIndex
