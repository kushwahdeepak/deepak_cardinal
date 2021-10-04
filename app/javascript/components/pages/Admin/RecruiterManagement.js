import React, { useState, useEffect } from 'react'
import moment from 'moment'

import Card from './shared/Card'
import Table from './shared/Table'
import Paginator from '../../common/Paginator/Paginator'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import Button from './shared/Button'
import P from './shared/P'
import TableWrapper from './shared/TableWrapper'
import SearchBar from '../../common/SearchBar/SearchBar'

const RecruiterManagement = () => {
    const [activePage, setActivePage] = useState(0)
    const [pageCount, setPageCount] = useState(0)
    const [onDemandRecruiters, setOnDemandRecruiters] = useState([])
    const [showOnDemandRecruiters, setShowOnDemandRecruiters] = useState(false)
    const [recruiters, setRecruiters] = useState([])
    const [searchTerm, setSearchTerm] = useState('')

    const fetchData = () => {
        const url = `/admin/recruiters.json?page=${
            activePage + 1
        }&search=${searchTerm}`
        makeRequest(url, 'get', '', {
            contentType: 'application/json',
            loadingMessage: 'Fetching...',
            createSuccessMessage: (response) => response.data.message,
            onSuccess: (response) => {
                setRecruiters(
                    response.data.users.map((user) => ({
                        id: user.id,
                        name: user.first_name + ' ' + user.last_name,
                        email: user.email,
                        role: user.role,
                        created_at: user.created_at,
                        email_confirmed: user.email_confirmed ? 'Approved' : 'Pending',
                        send_email_request: user.send_email_request ? 'Approved' : 'Pending',
                        user_approved: user.user_approved !== null ? (user.user_approved ? 'Approved' : 'Rejecct') : 'Pending',
                    }))
                )
                setPageCount(response.data.total_pages)
            },
        })
    }
    const fetchOnDemandData = () => {
        const url = `/admin/recruiters/pending?page=${
            activePage + 1
        }&search=${searchTerm}`
        makeRequest(url, 'get', '', {
            contentType: 'application/json',
            loadingMessage: 'Fetching...',
            createSuccessMessage: (response) => response.data.message,
            onSuccess: (response) => {
                setOnDemandRecruiters(
                    response.data.users.map((user) => ({
                        id: user.id,
                        name: user.first_name + ' ' + user.last_name,
                        email: user.email,
                        role: user.role,
                        created_at: user.created_at,
                        email_confirmed: user.email_confirmed ? 'Approved' : 'Pending',
                        send_email_request: user.send_email_request ? 'Approved' : 'Pending',
                        user_approved: user.user_approved !== null ? (user.user_approved ? 'Approved' : 'Rejecct') : 'Pending',
                    }))
                )
                setPageCount(response.data.total_pages)
            },
        })
    }

    const fetchAppropriateData = () => {
        if (showOnDemandRecruiters) {
            fetchOnDemandData()
        } else {
            fetchData()
        }
    }

    useEffect(() => {
        fetchAppropriateData()
        window.scrollTo({ top: 0, behavior: 'smooth' })
    }, [activePage, showOnDemandRecruiters])

    const deleteRecruiter = async (id) => {
        setRecruiters(recruiters.filter((r) => r.id != id))
        const url = `/admin/recruiters/${id}`
        const response = await makeRequest(url, 'delete', {
            contentType: 'application/json',
            loadingMessage: 'Submitting...',
            createSuccessMessage: (response) => response.data.message,
        })
    }

    const approveRecruiter = async ({ data }) => {
        const url = `/admin/recruiters/${data.id}/approve`
        await makeRequest(url, 'put', '', {
            createSuccessMessage: () => 'Recruiter approved successfully',
            onSuccess: () => {
                fetchData()
                switchToRecruites()
            },
        })
    }

    const rejectRecruiter = async (id) => {
        const url = `/admin/recruiters/${id}/reject`
        await makeRequest(url, 'put', '', {
            createSuccessMessage: () => 'Recruiter rejected successfully',
            onSuccess: () => {
                fetchData()
                switchToRecruites()
            },
        })
    }

    const saveRecruiter = (newRec) => {
        // to do call backend to save updated data
    }

    const switchToOnDemandRecruites = () => {
        setShowOnDemandRecruiters(true)
        setActivePage(0)
    }

    const switchToRecruites = () => {
        setShowOnDemandRecruiters(false)
        setActivePage(0)
    }

    return (
        <Card>
            <div
                className="d-flex justify-content-between align-items-center w-100"
                style={{ marginBottom: '42px' }}
            >
                <P size="28px" height="38px" color="#1D2447">
                    Recruiter Management
                </P>
                <SearchBar
                    placeholder="Search users..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    onEnterPressed={() => {
                        activePage === 0
                            ? fetchAppropriateData()
                            : setActivePage(0)
                    }}
                    onButtonClick={() => {
                        activePage === 0
                            ? fetchAppropriateData()
                            : setActivePage(0)
                    }}
                />
                <Button onClick={switchToOnDemandRecruites} className="ml-3">
                    Recruiter Requests
                </Button>
            </div>
            {showOnDemandRecruiters ? (
                <TableWrapper>
                    <div
                        className="d-flex justify-content-between align-items-center w-100"
                        style={{ marginBottom: '18px    ' }}
                    >
                        <P size="22px" height="30px" color="#1D2447">
                            On-Demand Recruiter Requests
                        </P>
                        <Button
                            onClick={switchToRecruites}
                            padding="1px 10px"
                            height="30px"
                            width="30px"
                            radius="15px"
                            background="#8599FF"
                        >
                            x
                        </Button>
                    </div>
                    <Table
                        columNames={[
                            {
                                name: 'No.',
                                field: 'id',
                                editable: false,
                                type: 'text',
                            },
                            {
                                name: 'Recruiter Name',
                                field: 'name',
                                editable: false,
                                type: 'text',
                            },
                            {
                                name: 'Email',
                                field: 'email',
                                editable: false,
                                type: 'text',
                            },
                            {
                                name: 'Email Verification',
                                field: 'send_email_request',
                                editable: false,
                                type: 'text',
                            },
                            {
                                name: 'Account Verification',
                                field: 'email_confirmed',
                                editable: false,
                                type: 'text',
                            },
                            {
                                name: 'Requested On',
                                field: 'created_at',
                                editable: false,
                                type: 'text',
                            },
                            {
                                name: 'Options',
                                field: 'options',
                                editable: false,
                                type: 'text',
                            },
                        ]}
                        rowValues={onDemandRecruiters.map((o) => ({
                            ...o,
                            created_at: moment(o.created_at).format(
                                'YYYY-MM-DD'
                            ),
                        }))}
                        deleteAction={rejectRecruiter}
                        saveAction={approveRecruiter}
                        activePage={activePage}
                        goToEditPage={(id) =>
                            (window.location.href = '/admin/recruiters/' + id)
                        }
                    />
                </TableWrapper>
            ) : (
                <Table
                    columNames={[
                        {
                            name: 'No.',
                            field: 'id',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'Recruiter Name',
                            field: 'name',
                            editable: true,
                            type: 'text',
                        },
                        {
                            name: 'Email',
                            field: 'email',
                            editable: true,
                            type: 'text',
                        },
                        
                        {
                            name: 'Email Verification',
                            field: 'send_email_request',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'Account Verification',
                            field: 'email_confirmed',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'On-Demand',
                            field: 'user_approved',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'Created On',
                            field: 'created_at',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'Options',
                            field: 'options',
                            editable: false,
                            type: 'text',
                        },
                    ]}
                    rowValues={recruiters.map((o) => ({
                        ...o,
                        created_at: moment(o.created_at).format('YYYY-MM-DD'),
                    }))}
                    showEditOption
                    deleteAction={deleteRecruiter}
                    saveAction={saveRecruiter}
                    activePage={activePage}
                    goToEditPage={(id) =>
                        (window.location.href = '/admin/recruiters/' + id)
                    }
                />
            )}

            {pageCount > 1 && (
                <div
                    className="d-flex justify-content-center"
                    style={{ marginTop: 'auto' }}
                >
                    <Paginator
                        activePage={activePage}
                        setActivePage={setActivePage}
                        pageCount={pageCount}
                        pageWindowSize={5}
                        showGoToField={false}
                    />
                </div>
            )}
        </Card>
    )
}

export default RecruiterManagement
