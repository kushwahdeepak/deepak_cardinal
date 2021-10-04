import React, { useState, useEffect, useContext, useRef } from 'react'
import Table from 'react-bootstrap/Table'
import Form from 'react-bootstrap/Form'
import isNil from 'lodash.isnil'
import Paginator from '../Paginator/Paginator'
import MatchScore from '../MatchScore/MatchScore'
import StageSelector from '../StageSelector/StageSelector'
import CandidateGrader from '../CandidateGrader/CandidateGrader'
import moment from 'moment'
import styles from './styles/CandidateTable.module.scss'
import { StoreDispatchContext } from '../../../stores/JDPStore'
import isEmpty from 'lodash.isempty'
import Util from '../../../utils/util'
import { Card, Container, Col, Button, DropdownButton, Image } from 'react-bootstrap'
import profileImage from '../../../../assets/images/icons/profile.png'
import Badge from "react-bootstrap/Badge";
import './styles/CandidateTable.scss'
import applicationIcon from '../../../../assets/images/icons/application.png'
import lastActivityIcon from '../../../../assets/images/icons/lastactivity.png'
import lastContactIcon from '../../../../assets/images/icons/lastcontact.png'
import NavbarCollapse from 'react-bootstrap/esm/NavbarCollapse'
import _ from 'lodash'
import Alert from 'react-bootstrap/Alert'
import { CSVLink } from 'react-csv'
import { makeRequest } from '../RequestAssist/RequestAssist'
import Modal from 'react-bootstrap/Modal'
import Dropdown from 'react-bootstrap/Dropdown'
import LinkedinIcon from '../../../../assets/images/icons/linkedin.png'

const MAX_SELECTION_LIMIT = 200
const CANDIDATES_PER_PAGE = 25

function CandidateTable({
    loading,
    candidates,
    page,
    jobId,
    stage,
    handlePageChangeClick,
    totalPages,
    allSelectedCandidates,
    totalCandidateCount,
    enableStages,
    refreshCandidates,
    columns,
    displayCount,
    candidatePage,
    jobs,
    candidateSource
}) {
    const [selectionLimit, setSelectionLimit] = useState(
        Math.min(MAX_SELECTION_LIMIT, totalCandidateCount)
    )

    const [lastContact, setLastContact] = useState({
        active: false, id: null })
    const [application, setApplication] =  useState({
        active: false, id: null })
    const [lastActive, setLastActive] =  useState({
        active: false, id: null })
    const { dispatch, state } = useContext(StoreDispatchContext)
    const [transactionData, setTransactionData] = useState([])
    const [validationErrors, setValidationErrors] = useState({})
    const csvLink = useRef()
    const [openModal, setOpenModal] = useState(false)
    const [selectedJobs, setSelectedJobs] = useState('')
    const [selectedJobId, setSelectedJobId] = useState('')

    useEffect(
        () =>
            setSelectionLimit(
                Math.min(MAX_SELECTION_LIMIT, totalCandidateCount)
            ),
        [totalCandidateCount]
    )

    const handleCloseModal = () => {
        setOpenModal(false)
    }

    const candidateClickHandler = (candidate) =>
        dispatch({
            type: 'show_candidate',
            candidate,
        })
    const handleImport = async () => {
        if(isEmpty(allSelectedCandidates)){
            setValidationErrors({
                ...validationErrors,
                selectedcandidated: 'Please select candidate',
            })
            return
        }
        
        const candidates = allSelectedCandidates
        const candidateIds = candidates.map((candidate) => candidate.id)
        const payload = new FormData()

        payload.append('list_of_recipient_ids', candidateIds)
        let url = "/people/import_candidate"
        const result = await makeRequest(url, 'post', payload)
        .then((r) => setTransactionData(r.data))
        .catch((e) => console.log(e))
        csvLink.current.link.click()
    }    
    

    const selectAllChanged = () => {
        const newCheckedState = !state.selectAllChecked

        if (newCheckedState) {
            dispatch({ type: 'select_up_to_limit', limit: selectionLimit })
        } else {
            dispatch({ type: 'deselect_all' })
        }
    }

    const handleOpenModal = () => {
        if(isEmpty(allSelectedCandidates)){
            setValidationErrors({
                ...validationErrors,
                selectedcandidated: 'Please select candidate',
            })
            return
        }
        else{
            setOpenModal(true)
        }
    }
    
    const handleSubmit = async () => {
        const candidates = allSelectedCandidates
        const candidateIds = candidates.map((candidate) => candidate.id)
        const jobId = selectedJobId
        const formData = new FormData()
        formData.append('candidate_ids', candidateIds)
        formData.append('job_id', jobId)
        const url = `/move_candidate_tostage`
        try {
          const response = await makeRequest(url, 'post', formData, {
              contentType: 'multipart/form-data',
              loadingMessage: 'Submitting...',
              createResponseMessage: (response) => {
                return {
                  message: response.message ? response.message : ' '
                }
              },
          })
        }catch (e) {
          console.error(e.message)
        }
        dispatch({ type: 'deselect_all' })
        setOpenModal(false)
    }

    // Refreshes the actual checked items if we change the selectionLimit
    // while "select all" is already checked
    useEffect(() => {
        if (state.selectAllChecked) {
            dispatch({ type: 'select_up_to_limit', limit: selectionLimit })
        }
    }, [selectionLimit])

    if (loading) {
        return( <>
            <div className='container' style={{textAlign: 'center', margin: '119px -2px'}}>
                <h2>Loading....</h2> 
                <div id="loading" />
            </div>    
        </>
        )   
    }
    if (isEmpty(candidates)) {
        return( <>
            <div className='container' style={{textAlign: 'center', margin: '119px -2px'}}>
                <h2>No candidate found....</h2> 
            </div>    
        </>
)  
    }
    const handleJobFullName = (name) => {
      return name.length < 45? name : name.slice(0,42) + '...'
    }
    
    return (
        <>
            <div>
                <Modal show={openModal} onHide={handleCloseModal} className="ats-border" backdrop="static" keyboard={false}>
                    <Modal.Header closeButton>
                        <Modal.Title>Move Candidate To ATS</Modal.Title>
                    </Modal.Header>
                    <Modal.Body>
                        <Dropdown>
                            <Dropdown.Toggle style={{width: '28rem', marginBottom: '7px', height: '48px', fontSize: '17px'}} title={selectedJobs}>
                                {selectedJobs ? handleJobFullName(selectedJobs) : 'Select Job'}
                            </Dropdown.Toggle>
                            <Dropdown.Menu>
                            {jobs && jobs.length > 0 ? jobs.map((job) => (
                                    <Dropdown.Item
                                        key={job.id}
                                        onSelect={(e) => {
                                            setSelectedJobs(job.name)
                                            setSelectedJobId(job.id)
                                        }}
                                        value={job.id}
                                        eventKey={job.id}
                                    >
                                        {job.name}
                                    </Dropdown.Item>
                                )) : 
                                <Dropdown.Item>
                                    No Job Available For This Organization
                                </Dropdown.Item>
                            }
                            </Dropdown.Menu>
                        </Dropdown>
                    </Modal.Body>
                    <Modal.Footer>
                        <Button disabled={!selectedJobs} variant="primary" onClick={handleSubmit}>Move to stage</Button>
                        <Button variant="secondary" onClick={handleCloseModal}>
                            Close
                        </Button>
                    </Modal.Footer>
                </Modal>
            </div>
            <Table className={candidatePage ? styles.candidateTable : styles.table  }  responsive hover>
            <>
          {Object.values(validationErrors).map((error) => (
                            <Alert
                                key={error}
                                variant="danger"
                                onClose={() => setValidationErrors({})}
                                dismissible
                                className='candidate-table-close'
                            >
                                {error}
                            </Alert>
                        ))}
                        </>

                <thead>
                    <tr>
                        {columns.map((col,index) => {
                            switch (col) {
                                case 'select':
                                    return getSelectTH(index)
                                case 'image':
                                    return getCandidateImageTH(index)    
                                case 'candidate':
                                    return getCandidateTH(index)
                                case 'match':
                                    return getMatchTH(index)
                                case 'skills':
                                    return getSkillsTH(index)
                                case 'last-contacted':
                                    return getLastContactedTH(index)
                                case 'message':
                                    return getMessageTH(index)
                                case 'applied':
                                    return getAppliedTH(index)
                                case 'grading':
                                    return getGradingTH(index)
                                case 'candidate_search':
                                    return getCandidateCheck(index)    
                                default:
                                    return (
                                        <td className={styles.td}>
                                            unknown column: {col}
                                        </td>
                                    )
                            }
                        })}
                    </tr>
                </thead>
                <tbody>
                    {Array.isArray(candidates) &&
                        candidates.map((candidate, index) => {
                            return (
                                <CandidateRow
                                    candidate={candidate}
                                    jobId={jobId}
                                    cols={columns}
                                    idx={absoluteIndex(page, index)}
                                    key={index}
                                    clickHandler={candidateClickHandler}
                                    lastContact={lastContact}
                                    setLastContact={setLastContact}
                                    application={application}
                                    setApplication={setApplication}
                                    lastActive={lastActive}
                                    setLastActive={setLastActive}
                                    candidateSource={candidateSource}
                                />
                            )
                        })
                    }
                 </tbody>
            </Table>
            <div className={styles.tableFooter}>
                {totalPages > 1 && (
                    <Paginator
                        pageCount={totalPages}
                        pageWindowSize={5}
                        activePage={page}
                        setActivePage={(num) => handlePageChangeClick(num)}
                    />
                )}
            </div>
        </>
    )

    function getSelectTH() {
        return (
            <th key="select" className={styles.th}>
                <BulkSelector
                    value={selectionLimit}
                    checked={state.selectAllChecked}
                    onCheckChange={selectAllChanged}
                    onInputChange={(e) => {
                        if(e.target.value == ''){
                         setSelectionLimit(0)
                         return 
                        }
                        setSelectionLimit(Math.min(MAX_SELECTION_LIMIT, totalCandidateCount, parseInt(e.target.value)))
                    }}
                />
            </th>
        )
    }
    function getCandidateTH() {
        return (
            <th key="candidate" className={styles.th}>
                Candidate
            </th>
        )
    }

    function getCandidateImageTH() {
        return (
            <th key="candidateimage" className={styles.th} style={{ textAlign: 'center' }}>
                Image
            </th>
        )
    }

    function getCandidateCheck() {
        return (
            <>
                <div style={{float: 'left'}}>{getSelectTH()}</div>
                {!state.selectAllChecked &&
                    <label className={styles.labelHeader}  style={{marginTop: '15px',float: 'left'}}>
                        Select All
                    </label>
                }
                {displayCount}
                <div className="importButton">
                    <Dropdown>
                        <Dropdown.Toggle variant="primary" id="dropdown-basic" className="dropdown-text">
                            Services
                        </Dropdown.Toggle>

                        <Dropdown.Menu>
                            <Dropdown.Item onClick={handleOpenModal}>Move to ATS</Dropdown.Item>
                            <Dropdown.Item onClick={handleImport}>Export Linkedin URL</Dropdown.Item>
                        </Dropdown.Menu>
                    </Dropdown>
                </div>
                <CSVLink
                    data={transactionData}
                    filename='transactions.csv'
                    className='hidden'
                    ref={csvLink}
                    target='_blank'
                />  
                    
            </> 
        )
    }
    function getMatchTH() {
        return (
            <th
                key="match"
                className={styles.th}
                style={{ textAlign: 'center' }}
            >
                Match
            </th>
        )
    }
    function getSkillsTH() {
        return (
            <th key="skills" className={styles.th}>
                Skills
            </th>
        )
    }
    function getLastContactedTH() {
        return (
            <th key="last-contacted" className={styles.th}>
                Last contacted
            </th>
        )
    }
    function getMessageTH() {
        return (
            <th key="message" className={`${styles.th}`}>
                <div className={styles.messageTHContainer}>
                    Message{' '}
                    {enableStages && (
                        <StageSelector
                            allSelectedCandidates={allSelectedCandidates}
                            refreshCandidates={refreshCandidates}
                            jobId={jobId}
                            stage={stage}
                        />
                    )}
                </div>
            </th>
        )
    }
    function getAppliedTH() {
        return (
            <th key="applied" className={styles.th}>
                Applied
            </th>
        )
    }
    function getGradingTH() {
        return (
            <th key="grading" className={styles.th}>
                Grading
            </th>
        )
    }
}

function BulkSelector({ value, checked, onCheckChange, onInputChange }) {
    return (
        <div style={{ position: 'relative' }}>
            <Form.Check
                type="checkbox"
                name="checkAll"
                checked={checked}
                onChange={onCheckChange}
            />
            {checked && (
                <span className={styles.bulkSelector}>
                    Select first
                    <input
                        value={value}
                        onChange={onInputChange}
                        className={styles.bulkSelectorInput}
                        type="text"
                    />
                    candidates
                </span>
            )}
        </div>
    )
}

function CandidateRow({ candidate, jobId, cols, idx, clickHandler, setLastContact, lastContact, setLastActive, lastActive, setApplication, application, candidateSource}) {
    const { state, dispatch } = useContext(StoreDispatchContext)
    const checked = state.selectedCandidates[idx] ? true : false

    const [visible, setVisible] = useState(6)


    const loadMore = () => {
        setVisible(visible + 6)
    }

    const loadLess = () => {
        setVisible(6)
    }


    const handleCheckboxChange = (event) => {
        dispatch({
            type: 'toggle_candidate_selection',
            candidate: !checked ? candidate : null,
            index: idx,
        })
    }
    return (
        <>
            <tr
                onClick={(e) => {
                    
                    if(e.type ==='click' && (e.target.localName == 'img' || e.target.localName == 'h6' || e.target.localName == 'label')) {
                        {e.target.innerText ==='Last Contact' ? 
                          handleActivityHandler('activeLastContact', candidate ) 
                        : e.target.innerText ==='Last Active' ?
                            handleActivityHandler('activeLastActive', candidate )
                        : e.target.innerText ==='Applications' ? handleActivityHandler('application', candidate ) : ''       
                        }
                    }
                    else {
                        if(candidateSource === 'submitted_candidates'){
                            clickHandler(candidate)
                        }
                    }
                    
                }}
            >

                {cols.map((col) => getCellForCol(candidate, col, loadMore))}
            </tr>
        </>
    )

    function handleActivityHandler(activeField, candidate) {
        
        switch (activeField) {

            case 'activeLastContact':
                setLastContact({
                    active: true, id: candidate.id})
                setLastActive({
                    active: false, id: null})
                setApplication({
                    active: false, id: null})
                return 'setLastContact'
            case 'activeLastActive':
                setLastActive({
                    active: true, id: candidate.id})
                setApplication({
                    active: false, id: null})
                setLastContact({
                    active: false, id: null})
                return 'activeLastActive'

            case 'application':
                setApplication({
                    active: true, id: candidate.id})
                setLastContact({
                    active: false, id: null})
                setLastActive({
                    active: false, id: null})
                return 'application'
            default:
                console.error('Unknown column', activeField)
                return <td className={styles.td}>unknown column: {activeField}</td>      
        }
    }            

    function getCellForCol(candidate, col, loadMore) {
        switch (col) {
            case 'select':
                return getSelectCell(candidate, col)
            case 'image':
                return getCandidateImage(candidate, col)    
            case 'candidate':
                return getCandidateCell(candidate, col)
            case 'match':
                return getMatchCell(candidate, col)
            case 'skills':
                return getSkillsCell(candidate, col)
            case 'last-contacted':
                return getLastContactedCell(candidate, col)
            case 'message':
                return getMessageCell(candidate, col)
            case 'applied':
                return getAppliedCell(candidate)
            case 'grading':
                return getGradingCell(candidate)
            case 'candidate_search':
                return  getCandidateDetail(candidate, loadMore)
            default:
                console.error('unknown column: ', col)
                return <td className={styles.td}>unknown column: {col}</td>
        }
    }

    function canidateSkills(skill, index){
        return(
                    <>
                        <Badge
                            pill
                            key={index}
                            variant="secondary"
                            className="skills-button d-inline-block text-truncate"                                                                                            
                        >
                            <label className='candidate-skills'> {skill} </label>
                        </Badge>{'   '}
                    </>
        )
    }

    function getCandidateDetail(candidate, loadMore ){
        return(
            <>
                <Card key={candidate.id}  className={styles.candidateProfileCard} >
                <Card.Body className='candidate-list'>
                    {getSelectCell(candidate)}
                    <div style={{margin: '-48px 0 0 35px'}} >
                        <div className='row' style={{marginBottom: '11px'}} onClick={(e) => clickHandler(candidate)}>
                            <img className={styles.candidateProfileImage} src={candidate.image_url ? candidate.image_url : profileImage} />
                            <div className={styles.cardBody + 'container'} >
                            <h5 className={styles.cardBodyName}>{ Util.handleUndefinedFullName(candidate?.first_name, candidate?.last_name) }</h5>
                                <h5 style={{fontSize: '16px'}}>{candidate.title }</h5>
                                <p style={{fontSize: '13px'}}>{candidate.location }</p>
                            </div>
                        </div>
                    
                        {candidate.experiences && <div className='container row' onClick={(e) => clickHandler(candidate)}>
                            <div>
                                <h6 >Experience</h6>  
                            </div>
                            <Col md={5}>
                                 <p className={styles.descriptionPage}>{candidate.experiences}</p> 
                            </Col>
                        </div>}
                        {candidate.degree && <div className='container row' onClick={(e) => clickHandler(candidate)}>
                            <div>
                                <h6>Education</h6>
                            </div>
                            <Col md={4}>
                                <p className={styles.descriptionPage}>{candidate.degree}</p>
                            </Col>
                        </div>}
                        {candidate.skills &&
                        <div className='container row' onClick={(e) => clickHandler(candidate)}>
                            <div>
                                <h6 className={styles.skillTitle}>Skills</h6>
                            </div>
                            <div className={styles.badge}> 
                                {candidate.skills.split(',').slice(0, visible).map((skill, index) => canidateSkills(skill, index))}
                                {visible  < candidate.skills.split(',').length && (
                                    <Badge
                                        pill
                                        variant="secondary"
                                        className='skills-more-button  d-inline-block text-truncate' 
                                        >
                                        <label onClick={loadMore}>View More</label>
                                    </Badge>
                                )}
                                {visible  > candidate.skills.split(',').length && candidate.skills.split(',').length > 6 && (
                                    <Badge
                                        pill
                                        variant="secondary"
                                        className='skills-more-button  d-inline-block text-truncate'
                                        >
                                            <label onClick={loadLess}>View Less</label>
                                    </Badge>
                                )}
                            </div> 
                        </div>}
                        <div className='container row' style={{alignItems: 'center'}}>
                            <div>
                                <h6 >Activity</h6>
                            </div> {'  '}
                            <div className='activity-class' style={{display: 'contents'}}>
                           
                        
                                <div
                                    className='activity-field'
                                >
                                    <h6 style={{
                                        backgroundColor: (lastContact.id == candidate.id && lastContact.active) ?  '#E4EAFF' : '',
                                        borderRadius: (lastContact.id == candidate.id && lastContact.active) ? '20px' : '',
                                        padding: (lastContact.id == candidate.id && lastContact.active) ? '12px 12px' : ''
                                    }}>
                                        <img src={lastContactIcon}/>
                                        <label
                                            className={styles.activityFieldTitle}
                                             style={{
                                                borderRadius: application ? '20px' : '',
                                            }}
                                        > Last Contact </label>
                                    </h6>
                                </div>
                                <div
                                    className='activity-field'
                                >
                                    <h6 style={{
                                        backgroundColor: (application.id == candidate.id && application.active) ? '#E4EAFF' : '',
                                        borderRadius: (application.id == candidate.id && application.active) ? '20px' : '',
                                        padding: (application.id == candidate.id && application.active) ? '12px 12px' : '',
                                        paddingRight: (application.id == candidate.id && application.active) ? '26px' : '',
                                    }}>
                                        <img src={applicationIcon}/>
                                        <label
                                        className={styles.activityFieldTitle}
                                         style={{
                                            // background: application ? '#E4EAFF' : '',
                                            borderRadius: application ? '20px' : '',
                                        }}

                                        > 
                                            Applications
                                             
                                        </label>
                                        {candidate.applications.length != 0 && (
                                            <Badge className={styles.applicationsCount} id="" variant='light'>{candidate.applications.length}</Badge>
                                        )}
                                    </h6>
                                   
                                </div>
                                <div
                                    className='activity-field'
                                >
                                    <h6 style={{
                                        backgroundColor: (lastActive.id == candidate.id && lastActive.active) ? '#E4EAFF' : '',
                                        borderRadius: (lastActive.id == candidate.id && lastActive.active) ? '20px' : '',
                                        padding: (lastActive.id == candidate.id && lastActive.active) ? '12px 12px' : ''
                                    }}>
                                        <img src={lastActivityIcon}/>
                                       <label
                                       className={styles.activityFieldTitle}
                                       style={{
                                            borderRadius: application ? '20px' : '',
                                        }}

                                       > Last Active </label> 
                                    </h6>
                                </div>
                                <div
                                    className='activity-field'
                                >
                                    <Image
                                            src={LinkedinIcon}
                                            style={{
                                                width: '16px',
                                                height: '16px',
                                                marginLeft: '19px',
                                                float:'left',
                                                marginTop: '-4px'
                                            }}
                                        />
                                    <h6 style={{color: '#2a346f', marginLeft: 0, marginTop: '-4px'}}>
                                        
                                       <label style={{margin:0}}>
                                            <a style={{color: '#2a346f'}}
                                            href={candidate.linkedin_profile_url}
                                            target="_blank"
                                            >
                                            Linkedin Profile
                                            </a>
                                        </label>
                                    </h6>
                                </div>

                                {  lastContact.id == candidate.id && lastContact.active && !isEmpty(candidate.last_contacted_content) &&
                                        <div className='container'>
                                        <hr/>
                                            <div className='row contact_time'>
                                               <img src={lastContactIcon} style={{height: '19px',  marginRight: '12px'}} />  1 email received from {state.user.first_name} on {moment(application.last_contacted_time).format('MMM Do YYYY')} <br/> {candidate.last_contacted_content }
                                            </div>
                                        </div> 
                                }

                                { application.id == candidate.id && application.active &&
                                        <div className='container'>
                                            <hr/>
                                            <span> Recent Application</span>
                                            { candidate.applications.map((application)=>(
                                                <div className='row contact_time'>
                                                  <img src={applicationIcon} style={{height: '19px', marginRight: '12px'}}/> 
                                                    {application.name} <b style={{marginLeft: "5px"}}>Stage:</b> <span style={{textTransform: "capitalize"}}> {application.stage.stage.replace("_", " ")} &nbsp;  Applied on &nbsp; {moment(application.stage.created_at).format('MM/DD/YY')}</span>
                                                </div>   
                                            ))}
                                        </div> 
                                }
                                 {  lastActive.id == candidate.id && lastActive.active && !isEmpty(candidate.last_login) &&
                                        <div className='container'>
                                        <hr/>
                                        <span>Last Active</span>
                                            <div className='row'>

                                             <img src={lastActivityIcon} style={{height: '19px',  marginRight: '12px'}}/>  {moment(candidate.last_login).format('MM/DD/YY')  }
                                            </div>
                                    </div> 
                                }
                              
                            </div>
                        </div>
                    </div>                        
                </Card.Body>    
                </Card>
                <br/>
            </>
        )
    }

    function getSelectCell(candidate, col) {
        return (
            <td
                key={col + candidate.id}
                style={{ width: '2rem'}}
                className={styles.td + ' align-middle'}
                
            >
                <Form.Check
                    className={styles.candidateCheckbox}
                    type="checkbox"
                    value={candidate.name}
                    name={candidate.name}
                    checked={checked}
                    onChange={handleCheckboxChange}
                    onClick={(event) => event.stopPropagation()}
                />
            </td>
        )
    }

    function getCandidateImage(candidate, col) {
        return (
            <td
                key={col + candidate.id}
                style={{ width: '2rem'}}
                className={styles.td + ' align-middle'}
            >
                <img className={styles.candidateProfileImage} src={candidate.image_url ? candidate.image_url : profileImage} />
            </td>
        )
    }



    function getCandidateCell(candidate) {
        return (
            <td
                key={'candidate_' + candidate.id}
                className={styles.td}
                style={{ width: '10rem' }}
            >
                <span className={styles.candidateName}>
                {candidate.first_name + ' ' + Util.handleUndefined(candidate.last_name)}
                </span>
                <div className={styles.tdLine}>
                    {Util.candidateCompanyString(candidate)}
                </div>
                {candidate.location && (
                    <div className={styles.tdLine}>{candidate.location}</div>
                )}
                {!isEmpty(candidate.school) && (
                    <div className={styles.tdLine}>{candidate.school}</div>
                )}
            </td>
        )
    }

    function getMatchCell(candidate) {
        const matchScore = candidate.score
        return (
            <td
                key={'matchscore_' + candidate.id}
                className={styles.td}
                style={{ verticalAlign: 'middle' }}
            >
                <MatchScore score={matchScore} />
            </td>
        )
    }

    function getSkillsCell(candidate) {
        return (
            <td
                key={'skills_' + candidate.id}
                className={styles.tdEllipsis}
                style={{ width: '10rem' }}
                title={candidate.skills}
            >
                {candidate.skills}
            </td>
        )
    }

    function getLastContactedCell(candidate) {
        return (
            <td
                key={'last_contacted_' + candidate.id}
                className={styles.td}
                style={{ width: '8rem' }}
            >
                {!isEmpty(candidate.last_contacted) &&
                    moment(candidate.last_contacted).format('MM/DD/YY')}
            </td>
        )
    }

    function getMessageCell(candidate) {
        return (
            <td
                key={'message_' + candidate.id}
                className={styles.td}
                style={{ width: '15rem' }}
            ></td>
        )
    }

    function getAppliedCell(candidate) {
        let text = ''

        if (
            !isNil(candidate.submission) &&
            !isEmpty(candidate.submission.created_at)
        ) {
            text = moment(candidate.submission.created_at).format('MM/DD/YY')
        }

        return (
            <td
                key={'applied_' + candidate.id}
                className={styles.td}
                style={{ width: '15rem' }}
            >
                {text}
            </td>
        )
    }

    function getGradingCell(candidate) {
        return (
            <td
                key={'grade_' + candidate.id}
                className={styles.td}
                style={{ width: '15rem' }}
            >
                <CandidateGrader jobId={jobId} candidate={candidate} />
            </td>
        )
    }
}

function absoluteIndex(page, idx) {
    return page * CANDIDATES_PER_PAGE + idx
}

export default CandidateTable
