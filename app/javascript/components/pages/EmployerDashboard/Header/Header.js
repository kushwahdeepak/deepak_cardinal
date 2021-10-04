import React from 'react'
import styles from './styles/Header.module.scss'
import { ButtonGroup, Button, Row } from 'react-bootstrap'
import Initialize from '../../../Initialize'
import CustomModal from './CustomModal'
import SearchBar from '../../../common/SearchBar/SearchBar'
import Modal from 'react-bootstrap/Modal'

function Header({
    handleMyJobs,
    handleAllJobs,
    handleClosedJobs,
    setShowMyClosedJobs,
    setJobFilterText,
    setActivePage,
    handleSearch,
    showMyJobs,
    showMyClosedJobs,
    jobFilterText,
    loading,
    organization,
    currentUser,
    setReloaddata,
    reloadData,
    setOpenEmailSequenceModal,
    openEmailSequenceModal
}) {

    const handleCloseJobButton = () => {
        handleClosedJobs()
        setShowMyClosedJobs(true)
    }
    const handleAllJobsButton = () => {
        handleAllJobs()
        setShowMyClosedJobs(false)
    }
    const handleMyJobsButton = () => {
        handleMyJobs()
        setShowMyClosedJobs(false)
    }
    const loadJobDetailsData=()=>{
        window.location.reload()
    }
    
    return (
        <div className={styles.headerContainer}>
            <ButtonGroup className={styles.buttonContainer}>
                <Button
                    style={{
                        background: `${showMyJobs ? '#4C68FF' : ' #EBEDFA'}`,
                        color: `${showMyJobs ? ' #EBEDFA' : '#4C68FF'}`,
                        borderRadius:'10px'
                    }}
                    disabled={loading}
                    className={styles.jobButton}
                    onClick={() => handleMyJobsButton()}
                >
                    My Jobs
                </Button>
                <Button
                    style={{
                        background: `${!showMyJobs && !showMyClosedJobs ? '#4C68FF' : ' #EBEDFA'}`,
                        color: `${!showMyJobs && !showMyClosedJobs ? ' #EBEDFA' : '#4C68FF'}`,
                        borderRadius:'10px'
                    }}
                    disabled={loading}
                    className={styles.jobButton}
                    onClick={() => handleAllJobsButton()}
                >
                    {' '}
                    All Jobs
                </Button>
                <Button
                    style={{
                        background: `${!showMyJobs && showMyClosedJobs ? '#4C68FF' : '#EBEDFA'}`,
                        color: `${!showMyJobs && showMyClosedJobs ? '#EBEDFA' : '#4C68FF'}`,
                        borderRadius:'10px'
                    }}
                    disabled={loading}
                    className={styles.jobButton}
                    onClick={() => handleCloseJobButton()}
                >
                    {' '}
                    Closed Jobs
                </Button>
            </ButtonGroup>
            <SearchBar
                placeholder={'Search...'}
                value={jobFilterText}
                onChange={(e) => setJobFilterText(e.target.value)}
                onEnterPressed={() => {
                    setActivePage(0)
                    handleSearch()
                }}
                onButtonClick={() => {
                    setActivePage(0)
                    handleSearch()
                }}
            ></SearchBar>
            <div style={{ flexGrow: '1' }}></div>
            <Row>
                <Initialize>
                  <CustomModal
                    organization={organization}
                    currentUser={currentUser}
                    setReloaddata={setReloaddata}
                    reloadData={reloadData}
                    loadJobDetailsData={loadJobDetailsData}
                    setOpenEmailSequenceModal={setOpenEmailSequenceModal}
                    openEmailSequenceModal={openEmailSequenceModal}
                  />
                </Initialize>
            </Row>

            
        </div>
    )
}

export default Header
