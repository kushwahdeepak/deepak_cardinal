import React, { useState, useEffect } from 'react'
import moment from 'moment'

import Card from './shared/Card'
import Table from './shared/Table'
import Paginator from '../../common/Paginator/Paginator'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import Button from './shared/Button'
import P from './shared/P'
import { BlockBody, BlockHeader, DisplayPagination } from './styles/AdminDashboard.styled'
import TableWrapper from './shared/TableWrapper'
import SearchBar from '../../common/SearchBar/SearchBar'
import CompanyPlaceholderImage from '../../../../assets/images/talent_page_assets/company-placeholder.png'
import { PieChart, Pie, Tooltip, Cell } from 'recharts';

const OrganizationManagement = () => {
    const [activePage, setActivePage] = useState(0)
    const [pageCount, setPageCount] = useState(0)
    const [organizations, setOrganizations] = useState([])
    const [organizationRequests, setOrganizationRequests] = useState([])
    const [companySizes, setCompanySizes] = useState([])
    const [showOrganizationRequests, setShowOrganizationRequests] = useState(false)
    const [searchTerm, setSearchTerm] = useState('')
    const [todayPendingCount,setTodayPendingCount] = useState()
    const [pendingCount,setPendingCount] = useState()
    const [regionsCount,SetRegionsCount] = useState([])
    const [industriesCount,setIndustriesCount] = useState()
    const [totalOrganization,setTotalOrganization] = useState()
    const [totalApproved,setTotalApproved] = useState()
    const [currentCounts,setCurrentCounts] = useState()

    const COLORS = ["#0088FE", "#00C49F", "#FFBB28", "#FF8042"];

    const capitalize = (s) => {
        if (typeof s !== 'string') return ''
        return s.charAt(0).toUpperCase() + s.slice(1)
    }

    const fetchData = () => {
        const url = `/admin/organizations.json?page=${
            activePage + 1
        }&search=${searchTerm}`
        makeRequest(url, 'get', '', {
            contentType: 'application/json',
            loadingMessage: 'Fetching...',
            createSuccessMessage: (response) => response.data.message,
            onSuccess: (res) => {
                setOrganizations(
                    res.data.organizations.map((org) => ({
                        id: org.id,
                        name: capitalize(org.name),
                        industry: org.industry,
                        company_size: org.company_size,
                        owner: org.owner.full_name,
                        created_at: org.created_at,
                        status: capitalize((org.status ==='declined') ? 'rejected': org.status),
                        image_url:(org.image_url != null && org.image_url != 'N/A') ? org.image_url : CompanyPlaceholderImage
                    }))
                )
                setPageCount(res.data.meta.total_pages)
                setTodayPendingCount(res.data.meta.today_pending_organization)
                setPendingCount(res.data.meta.pending)
                SetRegionsCount(res.data.meta.region_count)
                setIndustriesCount(res.data.meta.industry_count)
                setTotalOrganization(res.data.meta.total_organization)
                setTotalApproved(res.data.meta.approved)
                setCurrentCounts(res.data.meta.current_count)
            },
        })
    }

    const fetchOrganizationRequests = () => {
        const url = `/admin/organizations/pending.json?page=${
            activePage + 1
        }&search=${searchTerm}`
        makeRequest(url, 'get', '', {
            contentType: 'application/json',
            loadingMessage: 'Fetching...',
            createSuccessMessage: (response) => response.data.message,
            onSuccess: (res) => {
                console.log(res.data.organizations)
                setOrganizationRequests( 
                res.data.organizations.map((org) => ({
                    id: org.id,
                    name: capitalize(org.name),
                    industry: org.industry,
                    company_size: org.company_size,
                    owner: capitalize(org.owner.first_name)+' '+capitalize(org.owner.last_name),
                    created_at: org.created_at,
                    status: capitalize(org.status),
                    image_url:(org.image_url != null || org.image_url != 'N/A') ? org.image_url : CompanyPlaceholderImage
                }))
              )
                setPageCount(res.data.total_pages)
                setCurrentCounts(res.data.current_counts)
            },
        })
    }

    const fetchAppropriateData = () => {
        if (showOrganizationRequests) {
            fetchOrganizationRequests()
        } else {
            fetchData()
        }
    }

    useEffect(() => {
        fetchAppropriateData()
        window.scrollTo({ top: 0, behavior: 'smooth' })
    }, [activePage, showOrganizationRequests])

    const deleteOrganization = async (id) => {
        const url = `/admin/organizations/${id}`
        await makeRequest(url, 'delete', '', {
            createSuccessMessage: () => 'Organization deleted successfully',
            
            onSuccess: () => {
                fetchData()
            },
        })
    }

    const saveOrganization = async (orgData) => {
        if (orgData.data) {
            const formData = new FormData()
            for (var key in orgData.data) {
                formData.append(`organization[${key}]`, orgData.data[key])
            }

            const url = `/admin/organizations/${orgData.data.id}.json`
            await makeRequest(url, 'put', formData, {
                createSuccessMessage: () => 'Organization updated successfully',
                onSuccess: () => {
                    fetchData()
                },
            })
        }
    }

    const approveOrganization = async ({ data }) => {
        const url = `/admin/organizations/${data.id}/approve`
        await makeRequest(url, 'put', '', {
            createSuccessMessage: () => 'Organization approved successfully',
            onSuccess: () => {
                fetchData()
                switchToOrganizations()
            },
        })
       
    }

    const rejectOrganization = async (id) => {
        const url = `/admin/organizations/${id}/reject`
        await makeRequest(url, 'put', '', {
            createSuccessMessage: () => 'Organization rejected successfully',
            onSuccess: () => {
                fetchData()
                switchToOrganizations()
            },
        })
    }

    const switchToOrganizationRequests = () => {
        setShowOrganizationRequests(true)
        setActivePage(0)
    }

    const switchToOrganizations = () => {
        setShowOrganizationRequests(false)
        setActivePage(0)
        fetchData()
    }

    const approve = ({ data }) => {
        saveOrganization({ data: { id: data.id, status: 'approved' } })
        fetchOrganizationRequests()
        switchToOrganizations()
    }

    const reject = (id) => {
        saveOrganization({ data: { id: id, status: 'declined' } })
        switchToOrganizations()
    }

    return (
        <Card>
                <P size="28px" height="38px" color="#1D2447">
                    Organization Management
                </P>
                <div
                className="d-flex justify-content-between align-items-center w-100"
                style={{ marginBottom: '42px',marginTop:'50px' }}
                >
                <SearchBar
                    placeholder="Search organizations..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    onEnterPressed={() =>
                        activePage == 0
                            ? fetchAppropriateData()
                            : setActivePage(0)
                    }
                    onButtonClick={() =>
                        activePage == 0
                            ? fetchAppropriateData()
                            : setActivePage(0)
                    }
                />
                <Button onClick={switchToOrganizationRequests} className="ml-3">
                    Organization Requests
                </Button>
            </div>
                <div style={{ marginTop: '50px', marginBottom:'50px', display: 'flex' }}>
                    <div style={{ marginLeft: '50px' }}>
                        <BlockHeader width={300}>
                            <P size="16px" height="27px" color="#3F446E" style={{textAlign:'center'}}>
                                Organizations
                            </P>
                        </BlockHeader>
                        <BlockBody>
                            <P size="10px" height="14px" color="#3F446E">
                                Total
                            </P>
                            <P
                                size="20px"
                                height="27px"
                                color="#3F446E"
                                marginTop="5px"
                            >
                                {totalOrganization}
                            </P>
                        </BlockBody>
                        <BlockBody>
                            <P size="10px" height="14px" color="#3F446E">
                                Approved
                            </P>
                            <P
                                size="20px"
                                height="27px"
                                color="#3F446E"
                                marginTop="5px"
                            >
                                {totalApproved}
                            </P>
                        </BlockBody>
                        <BlockBody>
                            <P size="10px" height="14px" color="#3F446E">
                                Today
                            </P>
                            <P
                                size="20px"
                                height="27px"
                                color="#3F446E"
                                marginTop="5px"
                            >
                                {todayPendingCount}
                            </P>
                        </BlockBody>
                        <BlockBody>
                            <P size="10px" height="14px" color="#3F446E">
                                Pending
                            </P>
                            <P
                                size="20px"
                                height="27px"
                                color="#3F446E"
                                marginTop="5px"
                            >
                                {pendingCount}
                            </P>
                        </BlockBody>
                    </div>
                    <div style={{ marginLeft: '50px' }}>
                        {regionsCount &&
                            <>
                            <BlockHeader width={300} style={{marginLeft:'10%'}}>
                                <P size="16px" height="27px" color="#3F446E">
                                    Region Wise Organization
                                </P>    
                            </BlockHeader>
                            <PieChart width={400} height={300}>
                                <Pie
                                    data={regionsCount}
                                    labelLine={false}
                                    fill="#8884d8"
                                    dataKey="value"
                                >
                                    {regionsCount.map((entry, index) => (
                                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                                    ))}
                                </Pie>
                                <Tooltip/>
                            </PieChart>
                            </>
                        }
                    </div>
                    <div style={{ marginLeft: '50px' }}>
                        {industriesCount &&
                            <>
                                <BlockHeader width={300} style={{marginLeft:'10%'}}>
                                    <P size="16px" height="27px" color="#3F446E">
                                    Industry Wise Organization
                                    </P>    
                                </BlockHeader>
                                <PieChart width={400} height={300}>
                                    <Pie
                                    data={industriesCount}
                                    labelLine={false}
                                    fill="#8884d8"
                                    dataKey="value"
                                >
                                    {industriesCount.map((entry, index) => (
                                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                                    ))}
                                </Pie>
                                <Tooltip/>
                                </PieChart>
                            </>
                        }
                    </div>
                </div>
            <DisplayPagination>Displaying {currentCounts} of {showOrganizationRequests ? organizationRequests.length : totalOrganization} organizations</DisplayPagination>
            {showOrganizationRequests ? (
                <TableWrapper>
                    <div
                        className="d-flex justify-content-between align-items-center w-100"
                        style={{ marginBottom: '18px    ' }}
                    >
                        <P size="22px" height="30px" color="#1D2447">
                            Organization Requests
                        </P>
                        <Button
                            onClick={switchToOrganizations}
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
                                name: 'Organization Logo',
                                field: 'image_url',
                                editable: false,
                                type: 'text',
                            },
                            {
                                name: 'Organization Name',
                                field: 'name',
                                editable: false,
                                type: 'text',
                            },{
                                name: 'Owner Name',
                                field: 'owner',
                                editable: false,
                                type: 'text',
                            },
                            {
                                name: 'industry',
                                field: 'industry',
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
                                name: 'Status',
                                field: 'status',
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
                        rowValues={organizationRequests.map((o) => ({
                            ...o,
                            created_at: moment(o.created_at).format(
                                'DD MMMM YYYY'
                            ),
                            image_url: <img src={o.image_url} style={{height: '70px', width: '80px',borderRadius:'10px',marginLeft:'18px'}}/> 
                        }))}
                        deleteAction={rejectOrganization}
                        saveAction={approveOrganization}
                        activePage={activePage}
                        goToEditPage={(id) =>
                            (window.location.href = '/admin/organizations/' + id)
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
                            name: 'Organization Logo',
                            field: 'image_url',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'Organization Name',
                            field: 'name',
                            editable: true,
                            type: 'text',
                        },{
                            name: 'Owner Name',
                            field: 'owner',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'industry',
                            field: 'industry',
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
                            name: 'Status',
                            field: 'status',
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
                    rowValues={organizations.map((o) => ({
                        ...o,
                        created_at: moment(o.created_at).format('DD MMMM YYYY'),
                        image_url: <img src={o.image_url} style={{height: '70px', width: '80px',borderRadius:'10px',marginLeft:'18px'}}/> 
                    }))}
                    showEditOption
                    deleteAction={deleteOrganization}
                    saveAction={saveOrganization}
                    activePage={activePage}
                    goToEditPage={(id) =>
                        (window.location.href = '/admin/organizations/' + id)
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

export default OrganizationManagement
