import React, { useState, useEffect } from 'react'
import {Container, OverlayTrigger, Dropdown, Tooltip, Button, Row, Col, Tab, Tabs, Popover, Card, Alert,Spinner} from 'react-bootstrap'
import {
    FacebookShareButton, FacebookIcon, TwitterShareButton,
    TwitterIcon, LinkedinShareButton, LinkedinIcon,
} from 'react-share'
import JobDescriptionModal from '../../common/modals/JobDescriptionModal/JobDescriptionModal'
import isEmpty from 'lodash.isempty'
import feather from 'feather-icons'
import RefinementPage from '../RefinementPage/RefinementPage'
import styles from './styles/JobDetailPage.module.scss'
import EditIcon from '../../../../assets/images/icons/pencil-icon.svg'
import TrashIcon from '../../../../assets/images/icons/trash-icon.svg'
import PlusIcon from '../../../../assets/images/icons/plus-icon.svg'
import UploadIcon from '../../../../assets/images/icons/upload-icon.svg'
import ShareIcon from '../../../../assets/images/icons/share-icon.svg'
import MultiEmailIcon from '../../../../assets/images/icons/multi-email.png'
import './styles/JobDetailPage.scss'
import 'react-datepicker/dist/react-datepicker.css'
import 'toasted-notes/src/styles.css'
import CandidateManager from '../../common/CandidateManager/CandidateManager'
import BulkCandidateUpload from '../../common/BulkCandidateUpload/BulkCandidateUpload'
import Modal from 'react-bootstrap/Modal'
import Badge from "react-bootstrap/Badge";
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import Initialize from '../../../components/Initialize'
import CustomModal from '../../../components/pages/EmployerDashboard/Header/CustomModal.js'
import ReferralModal from '../../common/modals/JobDescriptionModal/ReferralModal'
import JobDeleteConfirmationModal from './JobDeleteConfirmationModal.js'
import { skillIsNotEmpty } from '../../../utils'
import JobExtendConfirmationModal from './JobExtendConfirmationModal.js'
import moment from 'moment'
import EmailSequence from '../../common/EmailSequence/EmailSequence.js'

const LEADS = 'lead'
const APPLICANTS = 'applicant'
const SUBMITTED = 'submitted'
const FIRST_INTERVIEWS = 'first_interview'
const SECOND_INTERVIEWS = 'second_interview'
const OFFERS = 'offer'
const ARCHIVED = 'reject'
const RECRUITOR_SCREEN = 'recruitor_screen'
const ACTIVE_CANDIDATES = 'active_candidates'

const popover = (shareUrl) => {
    const content = (
        <Popover id="popover-basic">
            <Popover.Content>
                <FacebookShareButton
                    openShareDialogOnClick={false}
                    onClick={(_, url) => {
                        window.open(url, '_blank')
                    }}
                    style={{ marginLeft: 10 }}
                    url={shareUrl}
                    target="_blank"
                >
                    <FacebookIcon className={styles.shareIcon} round />
                </FacebookShareButton>

                <TwitterShareButton
                    openShareDialogOnClick={false}
                    onClick={(_, url) => {
                        window.open(url, '_blank')
                    }}
                    style={{ marginLeft: 10 }}
                    url={shareUrl}
                    target="_blank"
                >
                    <TwitterIcon className={styles.shareIcon} round />
                </TwitterShareButton>

                <LinkedinShareButton
                    openShareDialogOnClick={false}
                    onClick={(_, url) => {
                        window.open(url, '_blank')
                    }}
                    style={{ marginLeft: 10 }}
                    url={shareUrl}
                    target="_blank"
                >
                    <LinkedinIcon className={styles.shareIcon} round />
                </LinkedinShareButton>
            </Popover.Content>
        </Popover>
    )

    return content
}
function JobDetailPage({
  ATSBaseUrl,
  jobModel,
  currentUser,
  currentOrganization,
  organizationId,
  isEmailConfigured,
  stageTransition,
  showInviteFriends,
  publicUrl,
  jobStatus,
  memberOrganization,
  job_stage_count
})
{
  // Transform job and candidate models to be display-ready
  const Stage = localStorage.getItem('Stage')
  const [job, setJob] = useState(transformJobModel(jobModel))
  const [showJobDescriptionModal, setShowJobDescriptionModal] = useState(false)
  const [showReferralModal, setShowReferralModal] = useState(showInviteFriends)
  const [openModal, setOpenModal] = useState(false)
  const [openEmailSequenceModal, setOpenEmailSequenceModal] = useState(false)
  const [showRefinmentPage, setShowRefinementpage] = useState(false)
  const [activeTab, setActiveTab] = useState(Stage)
  const [isBulkUploadOpen, setIsBulkUploadOpen] = useState(false)
  const [isTrueModal, setIsTrueModal] = useState(true)
  const [buttonClose, setButtonClose] = useState(false)
  const [showUploadCandidatePanel, setShowUploadCandidatePanel] = useState(false)
  const [jobDelete, setJobDelete] = useState(false)
  const [openDeleteModal, setOpenDeleteModal] = useState(false)
  const [errorCreatingSubmission, setErrorCreatingSubmission] = useState(null)
  const [alertApplyForJob, setAlertApplyForJob] = useState(null)
  const [loading, setLoading] = useState(false)
  const [loadData, setLoadData] = useState(false)
  // Check whether the current user is an employee of Cardinal Talent
  const userBelongsToCT = currentOrganization?.name === window.ch_const.ct_org_name
  const showGradingUI = userBelongsToCT
  const [openExtendModal, setOpenExtendModal] = useState(false)
  const expiryDate = moment(jobModel?.expiry_date).format('YYYY-MM-DD')
  const beforeExpiryDate = moment(jobModel?.expiry_date).subtract(7, 'day').format('YYYY-MM-DD')
  const currentDate = moment(new Date()).format('YYYY-MM-DD')
  const [jobExtend, setJobExtend] = useState(false)
  const [value, setValue] = useState()
  const [isReadMore, setIsReadMore] = useState(true);
  const [showdisplaycount, setShowdisplaycount] = useState(false)
  const [disableCloseButton, setDisableCloseButton] = useState((currentUser.role == 'recruiter' && jobModel.creator_id == currentUser.id) || (currentUser.role == 'employer'))
  const toggleReadMore = () => {
    setIsReadMore(!isReadMore);
  };

  useEffect(() => {
    feather.replace()
  })

  const ReadMore = () => {
    let length = 20;
    const text = job?.description;
    const text_length = job?.description.replace(/<[^>]+>/g, '').replace(/&nbsp;/g, '').length;
    const [isReadMore, setIsReadMore] = useState(true);
    if (text_length < length) {
      return <div dangerouslySetInnerHTML={{__html: text}}/>;
    }

    return (
      <>
        {isReadMore ? text.replace(/<[^>]+>/g, '').replace(/&nbsp;/g, '').slice(0, length) : <div dangerouslySetInnerHTML={{__html: text}} />}
        {text_length > length && <span onClick={() => setIsReadMore(!isReadMore)} className="read-or-hide" style={{color:'#4C68FF'}}>
          {isReadMore ? "...read more" : " show less"}
        </span>}
      </>
    );
  };

    const handleModalOpen = () => {
        setOpenModal(true)
        setIsTrueModal(true)
    }

    const handleEmailSequenceModalOpen = () => {
      setOpenEmailSequenceModal(true)
    }

    const handleDeleteFunction = () => {
      setOpenDeleteModal(true)
      setJobDelete(true)
    }

    const handleOpenExtendModal = (value) => {
      setOpenExtendModal(true)
      setJobExtend(true)
      setValue(value)
    }


    const loadJobDetailsData = () => {
      window.location.reload()
    }

    useEffect(() => {
      setTimeout(() => {
        setLoadData(true);
      }, 1000);
    },[loadData])
    return (
        <>
          {openDeleteModal &&
            <JobDeleteConfirmationModal
              setJobDelete={setJobDelete}
              jobDelete={jobDelete}
              job={job}
            />
          }
          {openExtendModal &&
            <JobExtendConfirmationModal
              setJobExtend={setJobExtend}
              jobExtend={jobExtend}
              job={job}
              noDayExtend={value}
            />
          }
            <Container className={styles.pageTop + ' p-0 mt-5'} fluid>
              <div className={styles.titleRow}>
                  <h1 className={styles.jobTitle}>{job.name}</h1>
                      <div className={styles.mainButtons}>
                      <Button
                          className={`${!jobStatus ? 'upload-button-disable' : 'function-button'}`}
                          onClick={handleEmailSequenceModalOpen}
                          disabled={!jobStatus}
                      >
                          <img src={MultiEmailIcon} /> Email Sequence
                      </Button>
                      <Button
                          className={`${!jobStatus ? 'upload-button-disable' : 'function-button'}`}
                          onClick={handleModalOpen}
                          disabled={!jobStatus}
                      >
                          <img src={EditIcon} /> Edit job post
                      </Button>
                      <Button
                          onClick={handleDeleteFunction}
                          className={`${!jobStatus ? 'upload-button-disable' : 'function-button'}`}
                          disabled={disableCloseButton ? !jobStatus : true}
                      >
                          <img src={TrashIcon} /> Close job
                      </Button>

                         <Button
                         onClick={()=>setShowReferralModal(true)}
                         className={`${!jobStatus ? 'upload-button-disable' : 'function-button'}`}
                         disabled={!jobStatus}
                         >
                                <img src={PlusIcon} /> Invite to apply
                        </Button>

                      <Dropdown>
                          <Dropdown.Toggle
                              className={`${!jobStatus ? 'upload-button-disable' : 'upload-button'}`}
                              id="dropdown-basic"
                              disabled={!jobStatus}
                          >
                              <img src={UploadIcon} /> Upload candidates
                          </Dropdown.Toggle>

                          <Dropdown.Menu
                            align="right"
                            className="upload-candidate-button-menu"
                          >
                            <Dropdown.Item
                              onClick={() =>
                                setShowUploadCandidatePanel(
                                  (prevState) => !prevState
                                )
                              }
                            >
                            Add single candidate
                            </Dropdown.Item>
                              <Dropdown.Item
                                onClick={() =>
                                  setIsBulkUploadOpen(!isBulkUploadOpen)
                                }
                              >
                            Bulk upload
                            </Dropdown.Item>
                          </Dropdown.Menu>
                      </Dropdown>

                      {expiryDate >= beforeExpiryDate && beforeExpiryDate <= currentDate && expiryDate >= currentDate &&
                        <Dropdown>
                            <Dropdown.Toggle
                                className={`${!jobStatus ? 'upload-button-disable' : 'upload-button'}`}
                                id="dropdown-basic"
                                disabled={!jobStatus}
                            >
                                <img src={PlusIcon} /> Extend job
                            </Dropdown.Toggle>

                            <Dropdown.Menu
                              align="right"
                              className="upload-candidate-button-menu"
                            >
                              <Dropdown.Item
                                onClick={() =>{
                                  handleOpenExtendModal(15)
                                }}
                              >
                              15 Days
                              </Dropdown.Item>
                                <Dropdown.Item
                                  onClick={() =>{
                                    handleOpenExtendModal(30)
                                  }}
                                >
                              30 Days
                              </Dropdown.Item>
                            </Dropdown.Menu>
                        </Dropdown>
                      }

                        <OverlayTrigger
                            overlay={popover(publicUrl)}
                            trigger="click"
                            placement="top"
                        >
                            <Button className={`${!jobStatus ? 'upload-button-disable' : 'function-button'}`} disabled={!jobStatus}>
                                <img src={ShareIcon} /> Share this job
                            </Button>
                        </OverlayTrigger>
                    </div>
                </div>
                <Card className={styles.topWrapper}>
                    <Row>
                        <Col md="12">
                            <span className={styles.jobCompany}>{job.organization}</span><br></br>
                            <span className={styles.jobPosition}>{job.department || 'No department found'}</span><br></br>
                            <span className={styles.jobLocation}>{job.location}</span><br></br>
                        </Col>
                        <Col md="1" className="mt-3">
                            <span className={styles.categorySpan}>
                                About
                            </span>
                        </Col>
                        <Col md="11" className="mt-3">
                            <div
                                className={
                                    styles.jobDescriptionText
                                }
                                style={{ textAlign: `justify`,whiteSpace: 'pre-wrap' }}
                            >
                              {ReadMore()}
                            </div>
                        </Col>
                        { job.skills && (
                        <>
                            <Col md="1" className="mt-2" className="mt-3">
                                <span className={styles.categorySpan}>
                                    Must Have Skills
                                </span>
                            </Col>
                            <Col md="11" className="mt-3">
                            {job.skills?.map((skill,index) => skillIsNotEmpty(skill) &&
                                <Badge
                                        pill
                                        key={index}
                                        variant="secondary"
                                        className="skills-button d-inline-block text-truncate"
                                        >
                                <label className='candidate-skills'> {skill.toLowerCase()} </label>
                                </Badge>
                            )}
                            </Col>
                        </>
                        )}
                        { job.niceToHaveSkills && (
                        <>
                            <Col md="1" className="mt-2">
                                <span className={styles.categorySpan}>
                                    Nice to Have Skills
                                </span>
                            </Col>
                            <Col md="11" className="mt-2">
                                {job.niceToHaveSkills?.map((skill,index) => skillIsNotEmpty(skill) &&
                                <Badge
                                    pill
                                    key={index}
                                    variant="secondary"
                                    className="skills-button d-inline-block text-truncate"
                                >
                                    <label className='candidate-skills'> {skill.toLowerCase()} </label>
                                </Badge>
                            )}
                            </Col>
                        </>)}
                    </Row>
                </Card>
            </Container>
            { (alertApplyForJob || errorCreatingSubmission || loading) &&
              <Container>
                { alertApplyForJob && (
                            <Alert
                                variant="success"
                                onClose={() => setAlertApplyForJob(null)}
                                dismissible
                            >
                                {alertApplyForJob}
                            </Alert>
                        )}
                        {errorCreatingSubmission && (
                            <Alert
                                variant="danger"
                                onClose={() => setErrorCreatingSubmission(null)}
                                dismissible
                            >
                                {errorCreatingSubmission}
                            </Alert>
                        )}
                        {loading && (
                            <div className="d-flex justify-content-center">
                                <Spinner animation="border" role="status">
                                    <span className="sr-only">Loading...</span>
                                </Spinner>
                            </div>
                )}
              </Container>
            }
            <Container>
                {openModal ?
                    <Initialize>
                      <CustomModal
                        organization={currentOrganization}
                        currentUser={currentUser}
                        isTrueModal={isTrueModal}
                        setIsTrueModal={setIsTrueModal}
                        buttonClose={buttonClose}
                        job={jobModel}
                        loadData={loadData}
                        setLoadData={setLoadData}
                        loadJobDetailsData={loadJobDetailsData}
                        handleEmailSequenceModalOpen={handleEmailSequenceModalOpen}
                      />
                    </Initialize> : ''
                }
            </Container>

           {openEmailSequenceModal &&
             <Container>
                <Modal
                    className="custom-modal"
                    show={openEmailSequenceModal}
                    onHide={()=>setOpenEmailSequenceModal(false)}
                    size={'xl'}
                    aria-labelledby="contained-modal-title-vcenter"
                    backdrop="static"
                >
                  <Modal.Header closeButton>
                        <Modal.Title id="contained-modal-title-vcenter">
                            Email Sequence
                        </Modal.Title>
                  </Modal.Header>
                  <Modal.Body>
                    <EmailSequence
                      openEmailSequenceModal={openEmailSequenceModal}
                      job={job}
                      setOpenEmailSequenceModal={setOpenEmailSequenceModal}
                    />
                  </Modal.Body>
                </Modal>
              </Container>}

        <Container
          style={{ position: 'relative', paddingTop: '25px' }}
          className={`${styles.pageBottom + ' p-0'}`}
          fluid
        >
          {
            <div className="p-0">
              <Modal
                className="modelContainer"
                show={isBulkUploadOpen}
                onHide={() =>
                    setIsBulkUploadOpen(!isBulkUploadOpen)}
                onBackdropClick={!isBulkUploadOpen}
                aria-labelledby="contained-modal-title-vcenter"
                backdropClassName={styles.modalBackdrop}
                size="xl"
                scrollable
                centered
              >
              <Modal.Body className={styles.modalBody}>
                <div className={styles.contentContainer}>
                  <BulkCandidateUpload
                      ATSBaseUrl={ATSBaseUrl}
                      id={job.id}
                      hideHeaderText={true}
                  />
                  <div className={styles.contentText}>
                      These candidates will be added to "My{' '}
                      {activeTab?.replace('_', ' ')}" for this
                      job
                  </div>
                </div>
              </Modal.Body>
              </Modal>
                <Tabs
                  className="job-detail-tabs"
                  defaultActiveKey="applicant"
                  activeKey={activeTab}
                  onSelect={(t) => setActiveTab(t)}
                >
                <Tab eventKey={LEADS}
                     title={
                            <React.Fragment>
                              Leads
                              {job_stage_count?.leads != 0 && (
                              <Badge className={styles.stageCount} variant='light'>{job_stage_count?.leads}</Badge>
                              )}
                            </React.Fragment>
                          }
                >
                  {activeTab === LEADS && (
                    <CandidateManager
                      tableColumns={getTableColumnsForTab(
                          LEADS
                      )}
                      memberOrganization={memberOrganization}
                      currentOrganization={currentOrganization}
                      isEmailConfigured={isEmailConfigured}
                      user={currentUser}
                      stage={activeTab}

                      candidateSource="submitted_candidates"
                      placeholder='Search by first name, last name, skills'
                      jobId={job.id}
                      fullJob={job}
                      title={'Leads for ' + job.name}
                      showSearchField
                      showUploadCandidatePanel={
                          showUploadCandidatePanel
                      }
                      setShowUploadCandidatePanel={
                          setShowUploadCandidatePanel
                      }
                      currentOrganization={currentOrganization}
                      allowCandidateUpload
                      showdisplaycount={showdisplaycount}
                    />
                  )}
                </Tab>
                <Tab eventKey={ACTIVE_CANDIDATES}
                    title={
                            <React.Fragment>
                              Active Candidates
                              { job_stage_count?.active_candidates != 0 &&
                                <Badge className={styles.stageCount} variant='light'>{job_stage_count?.active_candidates}</Badge>
                              }
                              
                            </React.Fragment>
                          }
                >
                  {activeTab === ACTIVE_CANDIDATES && (
                    <CandidateManager
                      tableColumns={getTableColumnsForTab(
                        ACTIVE_CANDIDATES
                      )}
                      memberOrganization={memberOrganization}
                      currentOrganization={currentOrganization}
                      isEmailConfigured={isEmailConfigured}
                      user={currentUser}
                      stage={activeTab}
                      candidateSource="submitted_candidates"
                      jobId={job.id}
                      fullJob={job}
                      title={'Active Candidates for ' + job.name}
                      showUploadCandidatePanel={
                          showUploadCandidatePanel
                      }
                      setShowUploadCandidatePanel={
                          setShowUploadCandidatePanel
                      }
                      allowCandidateUpload
                      showdisplaycount={showdisplaycount}
                    />
                  )}
                </Tab>
                <Tab eventKey={APPLICANTS}
                    title={
                      <React.Fragment>
                       Applicants
                       {job_stage_count?.applicant != 0 && (
                        <Badge className={styles.stageCount} variant='light'>{job_stage_count?.applicant}</Badge>
                       )}
                      </React.Fragment>
                    }
                >
                  {activeTab === APPLICANTS && (
                    <CandidateManager
                      tableColumns={getTableColumnsForTab(
                        APPLICANTS,
                        showGradingUI
                      )}
                      memberOrganization={memberOrganization}
                      currentOrganization={currentOrganization}
                      isEmailConfigured={isEmailConfigured}
                      user={currentUser}
                      stage={activeTab}
                      candidateSource="submitted_candidates"
                      jobId={job.id}
                      fullJob={job}
                      title={'Applicants for ' + job.name}
                      showUploadCandidatePanel={
                          showUploadCandidatePanel
                      }
                      setShowUploadCandidatePanel={
                          setShowUploadCandidatePanel
                      }
                      allowCandidateUpload
                      showdisplaycount={showdisplaycount}
                    />
                  )}
                </Tab>

                <Tab
                  eventKey={RECRUITOR_SCREEN}
                  title={
                    <React.Fragment>
                      Recruiter screened
                      {job_stage_count?.recruiter != 0 && (
                      <Badge className={styles.stageCount} variant='light'>{job_stage_count?.recruiter}</Badge>
                      )}
                    </React.Fragment>
                  }
                >
                  {activeTab === RECRUITOR_SCREEN && (
                    <CandidateManager
                      tableColumns={getTableColumnsForTab(
                          RECRUITOR_SCREEN
                      )}
                      memberOrganization={memberOrganization}
                      currentOrganization={currentOrganization}
                      isEmailConfigured={isEmailConfigured}
                      user={currentUser}
                      stage={activeTab}
                      candidateSource="submitted_candidates"
                      jobId={job.id}
                      fullJob={job}
                      title={
                          'Recruiter screened for ' + job.name
                      }
                      showUploadCandidatePanel={
                          showUploadCandidatePanel
                      }
                      setShowUploadCandidatePanel={
                          setShowUploadCandidatePanel
                      }
                      allowCandidateUpload
                      showdisplaycount={showdisplaycount}
                    />
                  )}
                </Tab>

                <Tab
                    eventKey={SUBMITTED}
                    title={
                      <React.Fragment>
                        Submitted
                      {job_stage_count?.submitted != 0 && (
                        <Badge className={styles.stageCount} variant='light'>{job_stage_count?.submitted}</Badge>
                      )}
                      </React.Fragment>
                    }
                >
                  {activeTab === SUBMITTED && (
                    <CandidateManager
                      tableColumns={getTableColumnsForTab(
                          SUBMITTED
                      )}
                      isEmailConfigured={isEmailConfigured}
                      user={currentUser}
                      stage={activeTab}
                      memberOrganization={memberOrganization}
                      currentOrganization={currentOrganization}
                      candidateSource="submitted_candidates"
                      jobId={job.id}
                      fullJob={job}
                      title={
                          'Submitted interviews for ' + job.name
                      }
                      showUploadCandidatePanel={
                          showUploadCandidatePanel
                      }
                      setShowUploadCandidatePanel={
                          setShowUploadCandidatePanel
                      }
                      allowCandidateUpload
                      showdisplaycount={showdisplaycount}
                    />
                  )}
                </Tab>

                <Tab
                    eventKey={FIRST_INTERVIEWS}
                    title={
                      <React.Fragment>
                        First Interviews
                      {job_stage_count?.first_interview != 0 && (
                        <Badge className={styles.stageCount} variant='light'>{job_stage_count?.first_interview}</Badge>
                      )}
                      </React.Fragment>
                    }
                >
                  {activeTab === FIRST_INTERVIEWS && (
                    <CandidateManager
                      tableColumns={getTableColumnsForTab(
                          FIRST_INTERVIEWS
                      )}
                      memberOrganization={memberOrganization}
                      currentOrganization={currentOrganization}
                      isEmailConfigured={isEmailConfigured}
                      user={currentUser}
                      stage={activeTab}
                      candidateSource="submitted_candidates"
                      jobId={job.id}
                      fullJob={job}
                      title={
                          'First interviews for ' + job.name
                      }
                      showUploadCandidatePanel={
                          showUploadCandidatePanel
                      }
                      setShowUploadCandidatePanel={
                          setShowUploadCandidatePanel
                      }
                      allowCandidateUpload
                      showdisplaycount={showdisplaycount}
                    />
                  )}
                </Tab>

                <Tab
                  eventKey={SECOND_INTERVIEWS}
                  title={
                    <React.Fragment>
                      Second Interviews
                      {job_stage_count?.second_interview != 0 && (
                      <Badge className={styles.stageCount} variant='light'>{job_stage_count?.second_interview}</Badge>
                      )}
                    </React.Fragment>
                  }
                >
                  {activeTab === SECOND_INTERVIEWS && (
                    <CandidateManager
                      tableColumns={getTableColumnsForTab(
                          SECOND_INTERVIEWS
                      )}
                      memberOrganization={memberOrganization}
                      currentOrganization={currentOrganization}
                      isEmailConfigured={isEmailConfigured}
                      user={currentUser}
                      stage={activeTab}
                      candidateSource="submitted_candidates"
                      jobId={job.id}
                      fullJob={job}
                      title={
                          'Second Interviews for ' + job.name
                      }
                      showUploadCandidatePanel={
                          showUploadCandidatePanel
                      }
                      setShowUploadCandidatePanel={
                          setShowUploadCandidatePanel
                      }
                      allowCandidateUpload
                      showdisplaycount={showdisplaycount}
                    />
                  )}
                </Tab>

                <Tab eventKey={OFFERS}
                     title={
                      <React.Fragment>
                        Offers
                        {job_stage_count?.offer != 0 && (
                        <Badge className={styles.stageCount} variant='light'>{job_stage_count?.offer}</Badge>
                        )}
                      </React.Fragment>
                    }
                >
                  {activeTab === OFFERS && (
                    <CandidateManager
                      tableColumns={getTableColumnsForTab(
                          OFFERS
                      )}
                      memberOrganization={memberOrganization}
                      currentOrganization={currentOrganization}
                      isEmailConfigured={isEmailConfigured}
                      user={currentUser}
                      stage={activeTab}
                      candidateSource="submitted_candidates"
                      jobId={job.id}
                      fullJob={job}
                      title={'Offers for ' + job.name}
                      showUploadCandidatePanel={
                          showUploadCandidatePanel
                      }
                      setShowUploadCandidatePanel={
                          setShowUploadCandidatePanel
                      }
                      allowCandidateUpload
                      showdisplaycount={showdisplaycount}
                    />
                  )}
                </Tab>
                <Tab eventKey={ARCHIVED}
                     title={
                      <React.Fragment>
                        Archived
                        {job_stage_count?.archived != 0 && (
                        <Badge className={styles.stageCount} >{job_stage_count?.archived}</Badge>
                        )}
                      </React.Fragment>
                    }
                >
                  {activeTab === ARCHIVED && (
                    <CandidateManager
                      tableColumns={getTableColumnsForTab(
                          ARCHIVED
                      )}
                      memberOrganization={memberOrganization}
                      currentOrganization={currentOrganization}
                      isEmailConfigured={isEmailConfigured}
                      user={currentUser}
                      stage={activeTab}
                      candidateSource="submitted_candidates"
                      jobId={job.id}
                      fullJob={job}
                      title={'Archived for ' + job.name}
                      showUploadCandidatePanel={
                          showUploadCandidatePanel
                      }
                      setShowUploadCandidatePanel={
                          setShowUploadCandidatePanel
                      }
                      allowCandidateUpload
                      showdisplaycount={showdisplaycount}
                    />
                  )}
                </Tab>
            </Tabs>
        </div>
    }

                <JobDescriptionModal
                    job={job}
                    show={showJobDescriptionModal}
                    onHide={() => setShowJobDescriptionModal(false)}
                />
               { showReferralModal &&
                   <ReferralModal
                      job={job}
                      show={showReferralModal}
                      onHide={() => setShowReferralModal(false)}
                      onShow={() => setShowReferralModal(true)}
                      setErrorCreatingSubmission={(data) => {
                        setErrorCreatingSubmission(data)
                       }}
                      setAlertApplyForJob={(data) => {
                       setAlertApplyForJob(data)
                       }}
                    />
                }

            {showRefinmentPage && (
              <RefinementPage
                  job={job}
                  setJob={setJob}
                  transformJobModel={transformJobModel}
                  closeFunc={() => setShowRefinementpage(false)}
              />
            )}
        </Container>
      </>
    )
}

/*
 * Customize ruby model object for use on front-end
 */
function transformJobModel(model) {
    let {
        id,
        user_id,
        portalcompanyname,
        compensation,
        work_time,
        portalcity,
        name,
        description,
        gen_reqs,
        skills,
        pref_skills,
        benefits,
        niceToHaveSkills,
        department,
        referral_candidate,
        location_preference,
        organization,
    } = model

    const company = portalcompanyname
    const workingTime = work_time
    const location = portalcity
    compensation =
      !isEmpty(compensation) && compensation.charAt(0) !== '$'
        ? '$' + compensation
        : compensation
    const genReqs = gen_reqs?.split(',') ?? []
    skills = skills?.split(',') ?? []
    const prefSkills = pref_skills?.split(',') ?? []
    niceToHaveSkills = niceToHaveSkills?.split(',') ?? []
    benefits = benefits?.split(',') ?? []

    return {
        id,
        user_id,
        compensation,
        location,
        workingTime,
        company,
        name,
        description,
        genReqs,
        skills,
        prefSkills,
        benefits,
        niceToHaveSkills,
        department,
        referral_candidate,
        location_preference,
        organization
    }
}

/*
 * Contains the logic that determines which table columns
 * are shown on each of the different tabs.
 */
function getTableColumnsForTab(tabName, showGradingUI = false) {
  const defaultTableColumns = [
    'select',
    'image',
    'candidate',
    'match',
    'skills',
    'applied',
    'last-contacted',
    'message',
  ]

  if (tabName === LEADS || tabName === ARCHIVED) {
    // delete 'applied'
    const copy = defaultTableColumns.slice()
    copy.splice(4, 1)
    return copy
  }
  if (tabName === APPLICANTS && showGradingUI) {
    // insert 'grading'
    const copy = defaultTableColumns.slice()
    copy.splice(2, 0, 'grading')
    return copy
  }

  return defaultTableColumns
}

function buildJobAttrSection(attrName, attrVal) {
  const displayContent = Array.isArray(attrVal) ? attrVal.join(', ') : attrVal

  if (isEmpty(displayContent)) return ''

  return (
    <Container>
      <Row className="justify-content-between align-items-start mb-1">
        <span className={styles.categorySpan}>{attrName}:</span>
        <Col xl="10" className={styles.jobAttrText}>
          <p>{displayContent}</p>
        </Col>
      </Row>
    </Container>
  )
}

export default JobDetailPage
