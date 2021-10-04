import React, { useState, useEffect } from 'react'
import Navbar from 'react-bootstrap/Navbar'
import Nav from 'react-bootstrap/Nav'
import Button from 'react-bootstrap/Button'
import Image from 'react-bootstrap/Image'
import Dropdown from 'react-bootstrap/Dropdown'
import ProfileAvatar from '../../common/ProfileAvatar/ProfileAvatar'
import RecruiterOrganization from '../../pages/RecruiterOrganization/RecruiterOrganization'
import styles from './styles/Navbar.module.scss'
import LogoWithText from '../../../../assets/images/logos/navbar-logo.svg'
import avatar from '../../../../assets/images/img_avatar.png'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import axios from 'axios'

const NavBar = ({
    isAdmin,
    canPeopleSearch,
    canPeopleIntake,
    canJobView,
    userId,
    isTalent,
    isEmployer,
    isRecruiter,
    avatar_url,
    organization,
    currentUser,
    memberOrganization
}) => {
    const currentPathname = window.location.pathname

    const [recruiterOrganizations, setRecruiterOrganizations] = useState([])

    const userBelongsToCT = organization?.name === window.ch_const.ct_org_name
    const subOrgBelongsToCT = memberOrganization?.name === window.ch_const.ct_org_name

    const getOrganizations = async () => {
       const url = '/recruiter_organizations'

        const CSRF_Token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute('content')

        try {
            const response = await axios.get(`${url}`, {
                headers: {
                    'content-type': 'application/json',
                    'X-CSRF-Token': CSRF_Token,
                },
            })
            setRecruiterOrganizations(response.data.recruiter_organizations)
            
        } catch (e) {
            console.error(e.message)
        }

    }

     useEffect(() => {
        getOrganizations()
    }, [])
 
    const handleChangeOrganization = async(organization_id) => {
        const url = '/change_recruiter_organization'

        const payload = JSON.stringify({   
            organization_id: organization_id,
            user_id: userId
        })   
        const response = await makeRequest(url,'put', payload,{
            contentType: 'application/json',
            loadingMessage: 'changing organization...',
            createResponseMessage: (response)=>{
                return response.message   
            },  
            onSuccess: () => {
                setTimeout(() => {
                    window.location.href = '/employer_home'
                }, 1200)
            },  
        })
        // window.location.reload(true)

    }

    const guestLinks = (
        <>
            <Nav.Link
                href="/job_search"
                className={`${styles.navbarLink} ${
                    currentPathname === '/job_search'
                        ? styles.activeLinkColor
                        : ''
                }`}
            >
                Find Work
            </Nav.Link>
            <Nav.Link
                href="/welcome/employer"
                className={`${styles.navbarLink} ${
                    currentPathname === '/welcome/employer'
                        ? styles.activeLinkColor
                        : ''
                }`}
            >
                For Employers
            </Nav.Link>
            <Nav.Link
                href="/welcome/recruiter"
                className={`${styles.navbarLink} ${
                    currentPathname === '/welcome/recruiter'
                        ? styles.activeLinkColor
                        : ''
                }`}
            >
                For Recruiters
            </Nav.Link>

            <Nav.Link
                href="/welcome/refer_for_rewards"
                className={`${styles.navbarLink} ${
                    currentPathname === '/welcome/refer_for_rewards'
                        ? styles.activeLinkColor
                        : ''
                }`}
            >
                Refer for Rewards
            </Nav.Link>

            {/* <Nav.Link
                href="/welcome/on_demand_recruiter"
                className={`${styles.navbarLink} ${
                    currentPathname === '/welcome/on_demand_recruiter'
                        ? styles.activeLinkColor
                        : ''
                }`}
            >
                On-Demand Recruiter
            </Nav.Link> */}
        </>
    )
    const authLinks = (
        <>
            {isAdmin && (
                <Nav.Link
                    data-test="admin-link"
                    href="/admin"
                    className={`${styles.navbarLink} ${
                        currentPathname === '/admin'
                            ? styles.activeLinkColor
                            : ''
                    }`}
                >
                    Admin
                </Nav.Link>
            )}

            {(isEmployer || isRecruiter || isAdmin) && (
                <Nav.Link
                    href="/employer_home"
                    className={`${styles.navbarLink} ${
                        currentPathname === '/employer_home' ||
                        currentPathname === '/jobs/new'
                            ? styles.activeLinkColor
                            : ''
                    }`}
                >
                    My Jobs
                </Nav.Link>
            )}


            {(isEmployer || isRecruiter || isAdmin) && canPeopleSearch && (
                <Nav.Link
                    href="/people_searches/new"
                    className={`${styles.navbarLink} ${
                        currentPathname === '/people_searches/new'
                            ? styles.activeLinkColor
                            : ''
                    }`}
                >
                    Candidate Search
                </Nav.Link>
            )}
            {isAdmin && canPeopleIntake && (
                <Nav.Link
                    href="/candidates/new"
                    className={`${styles.navbarLink} ${
                        currentPathname === '/candidates/new'
                            ? styles.activeLinkColor
                            : ''
                    }`}
                >
                    Intake candidates
                </Nav.Link>
            )}

            {isAdmin && canJobView && (
                <Nav.Link
                    href="/jobs"
                    className={`${styles.navbarLink} ${
                        currentPathname === '/jobs'
                            ? styles.activeLinkColor
                            : ''
                    }`}
                >
                    Jobs
                </Nav.Link>
            )}
            {(isAdmin || isEmployer || isRecruiter) && (
                <Nav.Link
                    href="/scheduled_interviews"
                    className={`${styles.navbarLink} ${
                        currentPathname === '/scheduled_interviews'
                            ? styles.activeLinkColor
                            : ''
                    }`}
                >
                    Interviews
                </Nav.Link>
            )}

            {isRecruiter && (userBelongsToCT || subOrgBelongsToCT) && 
                <Nav.Link
                    href="/cardinal_jobs"
                    className={`${styles.navbarLink} ${
                        currentPathname === '/cardinal_jobs'
                            ? styles.activeLinkColor
                            : ''
                    }`}
                >
                    Cardinal Jobs
                </Nav.Link>
            }

            {(isTalent || isAdmin) && (
                <Nav.Link
                    href="/talent_home"
                    className={`${styles.navbarLink} ${
                        currentPathname === '/talent_home'
                            ? styles.activeLinkColor
                            : ''
                    }`}
                >
                    My Matches
                </Nav.Link>
            )}

            {(isTalent || isAdmin) && (
                <Nav.Link
                    href="/job_search"
                    className={`${styles.navbarLink} ${
                        currentPathname === '/job_search'
                            ? styles.activeLinkColor
                            : ''
                    }`}
                >
                    Find Work
                </Nav.Link>
            )}

            {(isTalent || isAdmin) && (
                <Nav.Link
                    href="/submissions/my_submissions"
                    className={`${styles.navbarLink} ${
                        currentPathname === '/submissions/my_submissions'
                            ? styles.activeLinkColor
                            : ''
                    }`}
                >
                    My Applications
                </Nav.Link>
            )}

            

            {(isEmployer || isAdmin) && (
                <>
                    <Nav.Link
                        href="/organizations"
                        className={`${styles.navbarLink} ${
                            currentPathname === '/organizations'
                                ? styles.activeLinkColor
                                : ''
                        }`}
                    >
                        Organizations
                    </Nav.Link>
                </>
            )}

            {(isTalent || isAdmin) && (
                <Nav.Link
                    href="/my_connections"
                    className={`${styles.navbarLink} ${
                        currentPathname === '/my_connections'
                            ? styles.activeLinkColor
                            : ''
                    }`}
                >
                    My Connections
                </Nav.Link>
            )}

            {/* {( isAdmin ) && (
                <Dropdown drop="down">
                    <Dropdown.Toggle
                        id="dropdown-basic"
                        className={styles.navbarUploadCandidatesButton}
                    >
                        &#43; Upload Candidates
                    </Dropdown.Toggle>

                    <Dropdown.Menu
                        align="right"
                        className={styles.navbarUploadCandidatesButtonMenu}
                    >
                        <Dropdown.Item href="/single_candidate_upload">
                            Add single candidate
                        </Dropdown.Item>
                        <Dropdown.Item href="/bulk_candidate_upload">
                            Bulk upload
                        </Dropdown.Item>
                    </Dropdown.Menu>
                </Dropdown>
            )} */}
        </>
    )

    const adminLinks = (
        <>
            <Nav.Link
                href="/admin/dashboard"
                className={`${styles.navbarLink} ${
                    currentPathname === '/admin/dashboard' ? styles.activeLinkColor : ''
                }`}
            >
                Home
            </Nav.Link>
            <Nav.Link
                href="/admin/recruiter_management"
                className={`${styles.navbarLink} ${
                    currentPathname === '/admin/recruiter_management'
                        ? styles.activeLinkColor
                        : ''
                }`}
            >
                Recruiters
            </Nav.Link>
            <Nav.Link
                href="/admin/organizations_management"
                className={`${styles.navbarLink} ${
                    currentPathname === '/admin/organizations_management'
                        ? styles.activeLinkColor
                        : ''
                }`}
            >
                Organizations
            </Nav.Link>
            <Nav.Link
                href="/admin/users"
                className={`${styles.navbarLink} ${
                    currentPathname === '/admin/users'
                        ? styles.activeLinkColor
                        : ''
                }`}
            >
                Users
            </Nav.Link>
            <Nav.Link
                href="/admin/reference_data_management"
                className={`${styles.navbarLink} ${
                    currentPathname === '/admin/reference_data_management'
                        ? styles.activeLinkColor
                        : ''
                }`}
            >
                Reference Data
            </Nav.Link>

            <Nav.Link
                href="/admin/jobs"
                className={`${styles.navbarLink} ${
                    currentPathname === '/admin/jobs'
                        ? styles.activeLinkColor
                        : ''
                }`}
            >
                Jobs
            </Nav.Link>
        </>
    )

    return (
        <Navbar
            expand="xl"
            className={'align-items-center py-0 ' + styles.navbarContainer}
        >
            <Navbar.Brand href="/" className="d-none d-xl-block">
                <Image src={LogoWithText} rounded className={styles.logo} />
            </Navbar.Brand>
            <Navbar.Toggle aria-controls="basic-navbar-nav" />
            <Navbar.Collapse id="basic-navbar-nav">
                <Nav className="align-items-center flex-wrap">
                    {userId && !isAdmin && authLinks}
                    {userId && isAdmin && adminLinks}
                    {!userId && guestLinks}
                </Nav>
            </Navbar.Collapse>
            {userId ? (
                <>
                    {/* <Button className={styles.chatLogo} type="button">
                        <svg
                            width="30"
                            height="25"
                            viewBox="0 0 30 25"
                            fill="none"
                            xmlns="http://www.w3.org/2000/svg"
                        >
                            <path
                                d="M0 10C0 4.47715 4.47715 0 10 0H20C25.5228 0 30 4.47715 30 10V25H10C4.47715 25 0 20.5228 0 15V10Z"
                                fill="url(#paint0_linear)"
                            />
                            <circle cx="15" cy="12" r="2" fill="white" />
                            <circle cx="22" cy="12" r="2" fill="white" />
                            <circle cx="8" cy="12" r="2" fill="white" />
                            <defs>
                                <linearGradient
                                    id="paint0_linear"
                                    x1="0"
                                    y1="0"
                                    x2="34"
                                    y2="29"
                                    gradientUnits="userSpaceOnUse"
                                >
                                    <stop stopColor="#4C68FF" />
                                    <stop offset="1" stopColor="#8E8BFF" />
                                </linearGradient>
                            </defs>
                        </svg>
                    </Button> */}

                    { isRecruiter  && (
                        <RecruiterOrganization
                            organization={organization}
                            recruiterOrganizations={recruiterOrganizations}
                            handleChangeOrganization={handleChangeOrganization}
                        />
                    )}
                    <ProfileAvatar
                        profileAvatar={avatar_url ? avatar_url : avatar}
                        userId={userId}
                        organization_id={organization ? organization.id : ''}
                        isEmployer={isEmployer}
                        currentUser={currentUser}
                    />
                </>
            ) : (
                <>
                    <a
                        href={`/users/sign_in?page=${
                            currentPathname == '/welcome/employer'
                                ? currentPathname
                                : currentPathname == '/welcome/recruiter'
                                ? currentPathname
                                : '/'
                        }`}
                        className={styles.navbarSignInButton}
                    >
                        Sign In
                    </a>
                    <Button
                        className={styles.navbarSignUpButton}
                        href={`/users/sign_up`}
                    >
                        Sign Up
                    </Button>
                </>
            )}
        </Navbar>
    )
}

export default NavBar
