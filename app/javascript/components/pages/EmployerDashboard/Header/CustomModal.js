import React, {useState} from 'react'
import {Modal, Button} from 'react-bootstrap'
import styles from './styles/Header.module.scss'
import ImportJobsModal from '../../../common/ImportJobsModal/ImportJobsModal'
import Body from './Body'
import './styles/Jobs.scss'
import StepBar from './StepBar'
import Alert from 'react-bootstrap/Alert'
import {Step1Context} from '../../../../context/Step1Context'
import {Step2Context} from '../../../../context/Step2Context'
import {Step3Context} from '../../../../context/Step3Context'

function CustomModal({
  organization,
  currentUser,
  isTrueModal=(false),
  setIsTrueModal,
  buttonClose=(true),
  job,
  setReloaddata,
  reloadData,
  loadData,
  setLoadData,
  loadJobDetailsData,
  handleEmailSequenceModalOpen,
  openEmailSequenceModal,
  setOpenEmailSequenceModal
}) {
  const [isOpen, setIsOpen] = useState(false)
  const [showModal, setShowModal] = useState(false)
  const [errorSubmitting, setErrorSubmitting] = useState(false)
  const default_organization = organization ? organization.id : ''
  const isPendingStatus = organization?.status === "pending"
  const {
    setName,
    setTitle,
    setLocation,
    setMustHave,
    setDescription,
    setNiceToHave,
    setEmailStepOne,
    setReferrals,
    setMoney,
    setLocationDepartment,
  } = React.useContext(Step1Context)
  const {
    setEmail,
    setSubject,
    setSms
  } = React.useContext(Step2Context)
  const {
    setMustHaveKeyword,
    setNiceToHaveKeyword,
    setEducationPreferrence,
    setCompanyPreferrence,
    setLocationPreferrence,
    setExperienceYears,
    setPreferredIndustry,
    setPreferredTitles,

  } = React.useContext(Step3Context)

  const handleClick = () => {
    if (default_organization) {
      setName('')
      setTitle('')
      setLocation('')
      setMustHave('')
      setDescription('')
      setNiceToHave('')
      setEmailStepOne('')
      setReferrals('')
      setMoney('')
      setEmail('')
      setSubject('')
      setSms('')
      setMustHaveKeyword('')
      setNiceToHaveKeyword('')
      setEducationPreferrence('')
      setCompanyPreferrence('')
      setLocationPreferrence('')
      setLocationDepartment('')
      setExperienceYears('')
      setPreferredIndustry('')
      setPreferredTitles('')
      setIsOpen(true)
    } else {
      setErrorSubmitting(true)
    }
  }
  const closeModal = () => {
    setIsOpen(false)
    if(setIsTrueModal !== undefined){
      setIsTrueModal(false)
    }
    if(setReloaddata !== undefined){
      setReloaddata(!reloadData)
    }
    loadJobDetailsData()
    setLoadData(true)
  }
  const handleModalClose = () => {
      setShowModal(false)
  }
  const handleModalShow = () => {
      setShowModal(true)
  }
  const showAlertMsg = () => {
    if(isPendingStatus) {
      return "Please contact Admin to approve your organization."
    }
    else{
      return "You do not belong to any Organization. Please select an Organization before adding a job."
    }
  }
  return (
    <>
      {errorSubmitting && (
          <Alert
              variant="danger"
              onClose={() => setErrorSubmitting(false)}
              dismissible
              style={{
                top: '89px',
                position: 'absolute',
                width: '90%',
                textAlign: 'center',
                left: '74px'
              }}
          >
            {showAlertMsg()}
          </Alert>
      )}
      {!isTrueModal && buttonClose ?
        <button className={styles.rowButton} onClick={handleClick}>&#43; Add New Jobs</button> : '' 
      }
      <ImportJobsModal
        handleModalClose={handleModalClose}
        showModal={showModal}
        organization_id={default_organization}
        setShowModal={setShowModal}
      />  
      {(isOpen || isTrueModal )&& (
        <Modal
          className="custom-modal"
          show={isOpen || isTrueModal}
          onHide={closeModal}
          size={'xl'}
          aria-labelledby="contained-modal-title-vcenter"
          backdrop="static"
        >
          <Modal.Header closeButton>
            <Modal.Title id="contained-modal-title-vcenter">{isTrueModal? "Edit Job" : "Add New Job"}
            <Button variant="info" type="button" onClick={handleModalShow}>
              Bulk Job import
            </Button>
            </Modal.Title>
          </Modal.Header>
          <StepBar 
            isTrueModal={isTrueModal}
          />
          <Body
            currentUser={currentUser}
            job={job}
            isTrueModal={isTrueModal}
            handleEmailSequenceModalOpen={handleEmailSequenceModalOpen}
            setIsTrueModal={setIsTrueModal}
            setOpenEmailSequenceModal={setOpenEmailSequenceModal}
            openEmailSequenceModal={openEmailSequenceModal}
          />
        </Modal>
      )}
    </>
  )
}

export default CustomModal;