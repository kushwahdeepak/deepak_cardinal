import React, { useState, useEffect } from 'react'
import moment from 'moment'

import Card from '../shared/Card'
import Table from '../shared/Table'
import Paginator from '../../../common/Paginator/Paginator'
import { makeRequest } from '../../../common/RequestAssist/RequestAssist'
import Button from '../shared/Button'
import P from '../shared/P'
import TableWrapper from '../shared/TableWrapper'
import SearchBar from '../../../common/SearchBar/SearchBar'
import AsyncSelect from "react-select/async"
import CandidateSkills from '../../../common/CandidateSkills/CandidateSkills'
import Select from 'react-select'
import CompanyPlaceholderImage from '../../../../../assets/images/talent_page_assets/company-placeholder.png'
import { DisplayPagination } from '../styles/AdminDashboard.styled'
import { Row, Col } from 'react-bootstrap'

const JobsIndex = () => {
    const [activePage, setActivePage] = useState(0)
    const [pageCount, setPageCount] = useState(0)
    const [jobs, setJobs] = useState([])
    const [jobsRequests, setJobsRequests] = useState([])
    const [searchTerm, setSearchTerm] = useState('')
    const [isLoading, setLoading] = useState(false)
    const [inputValue, setInputValue] = useState('')
    const [selectedOrganization, setSelectedOrganization]  = useState([])
    const [selectedStatus, setSelectedStatus]  = useState('all')
    const [member_options, setOptions] = useState([])
    const [selected,setSelected] = useState({value: 'all', label: 'All'})
    const [totalJobs,setTotalJobs] = useState(0)
    const [currentCounts,setCurrentCounts] = useState(0)
    const capitalize = (s) => {
        if (typeof s !== 'string') return ''
        return s.charAt(0).toUpperCase() + s.slice(1)
    }

    const fetchData = () => {
        const url = `/admin/jobs.json`
       
        makeRequest(url, 'get',  {params: {page: (activePage+1), query: searchTerm, status: selectedStatus, organization: selectedOrganization }}, {   
            contentType: 'application/json',
            loadingMessage: 'Fetching...',
            createSuccessMessage: (response) => response.data.message,
            onSuccess: (res) => {
                setJobs(
                    res.data.jobs.map((job) => ({
                        id: job.id,
                        name: capitalize(job.name),
                        skills: job.skills,
                        organization: job.organization_name,
                        expiry_date: job.expiry_date,
                        created_at: job.created_at,
                        status: capitalize(job.status),
                        organization_image: (job.organization_image != null) ? job.organization_image : CompanyPlaceholderImage
                    }))
                )
                setPageCount(res.data.total_pages)
                setTotalJobs(res.data.total_count)
                setCurrentCounts(res.data.current_counts)
            },
        })
    }

    const onClearFilter = async () => {
        setActivePage(0)        
        handleSelectStatus(0)
    }

    useEffect(() => {
        fetchData()
        window.scrollTo({ top: 0, behavior: 'smooth' })
    }, [activePage,selectedStatus,selectedOrganization,selected])

    const deleteJobs = async (id) => {
        const url = `/admin/jobs/${id}`
        await makeRequest(url, 'delete', '', {
            createSuccessMessage: () => 'Job deleted successfully',
            onSuccess: () => {      
                fetchData()
            },      
        })      
    }       

    const saveJobs = async (orgData) => {
        if (orgData.data) {
            const formData = new FormData()
            for (var key in orgData.data) {
                formData.append(`job[${key}]`, orgData.data[key])
            }
            const url = `/admin/jobs/${orgData.data.id}.json`
            await makeRequest(url, 'put', formData, {
                createSuccessMessage: () => 'Job updated successfully',
                onSuccess: () => {
                    fetchData()
                },
            })
        }
    }

    const addJobs = () => {
        window.location.href = '/admin/jobs/new'
    }

    const loadOptions = (inputValue, callback) => {
        setLoading(true)
        fetch(`/admin/organizations/get_organization?search=${inputValue}`)
        .then((res) => res.json())
        .then((res) => {
          let {organizations} = res
          setLoading(false)
          setOptions([...organizations.map((organization) => ({ value: organization.id, label: organization.name }))]);
        })
        .catch((err) => console.log("Request failed", err));
        callback(member_options);
    }
    const handleInputChange = (str) => {
        setInputValue(str)
        return str;
    }
    const handleSelectOption = (selectedOptions) => {
        setActivePage(0)
        setSelectedOrganization([...selectedOptions.map( ({value, label}) =>value)])
    }
    const handleSelectStatus = (selectedval) =>{
        setActivePage(0)
        setSelectedStatus(selectedval.value)
    }
    const filterOptions = [
        {value: 'all', label: 'All'},
        { value: 'active', label: 'Active' },
        { value: 'expired', label: 'Closed' },
        { value: 'pending', label: 'Pending' },
        { value: 'block', label: 'Blocked' }
    ]
   
    const colourStyles = {
        control: styles => ({ ...styles, backgroundColor: '#F6F7FC',minWidth:'16em',maxWidth:'16em',marginLeft:'10px',border: 'none',height:'40px' })
    };
    return (
        <Card>
            <div
                className="d-flex justify-content-between align-items-center w-100"
                style={{ marginBottom: '42px' }}
            >
                <P size="28px" height="38px" color="#1D2447" style={{width:'540px'}}>
                    Jobs List
                </P>
                <SearchBar
                    placeholder="Search job..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    onEnterPressed={() =>
                        activePage == 0
                            ? fetchData()
                            : setActivePage(0)
                    }
                    onButtonClick={() =>
                        activePage == 0
                            ? fetchData()
                            : setActivePage(0)
                    }
                />
                <Button onClick={addJobs} className="ml-3">
                    Add Job
                </Button>
            </div>
            
            <Row className="w-100" style={{ marginBottom: '10px' }}>
                <Col xs={12} sm={12} lg={6} style={{float:'left'}}>
                        <DisplayPagination>Displaying {currentCounts} of {totalJobs} jobs
                        </DisplayPagination>
                 </Col>
                 
                 <Col xs={12} sm={12} lg={3}>
                    <AsyncSelect
                        isMulti
                        isLoading={isLoading}
                        isClearable={true}
                        cacheOptions
                        loadOptions={loadOptions}
                        defaultOptions={selectedOrganization}
                        onInputChange={handleInputChange}
                        onChange={handleSelectOption}
                        placeholder={'Search by organization'}
                        styles={colourStyles}
                        noOptionsMessage={() => 'start typing the name of organization'}
                    />
                 </Col>
                <Col xs={12} sm={12} lg={3}>
                    <Select 
                    defaultValue={selected}
                    options={filterOptions} 
                    onChange={handleSelectStatus} 
                    placeholder={'Select Status'} 
                    styles={colourStyles}
                    />
                </Col>
            </Row>
           
            
                <Table
                    columNames={[
                        {
                            name: 'No.',
                            field: 'id',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'Job Name',
                            field: 'name',
                            editable: true,
                            type: 'text',
                        },{
                            name: 'Skills',
                            field: 'skills',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'Organization Logo',
                            field: 'organization_image',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'Organization',
                            field: 'organization',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'Expiry On',
                            field: 'expiry_date',
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
                            name: 'Action',
                            field: 'options',
                            editable: false,
                            type: 'text',
                        },
                    ]}
                    rowValues={jobs.map((o) => ({
                        ...o,
                        created_at: moment(o.created_at).format('MMMM DD, YYYY'),
                        expiry_date: moment(o.expiry_date).format('MMMM DD, YYYY'),
                        skills:  (o.skills != '') ? <CandidateSkills skills = {o.skills} /> :o.skills,
                        organization_image: (<img src={o.organization_image} style={{height: '50px', width: '60px',borderRadius:'10px',marginLeft:'18px'} }/> ) 
                    }))}
                    showEditOption
                    deleteAction={deleteJobs}
                    saveAction={saveJobs}
                    activePage={activePage}
                    goToEditPage={(id) =>
                        (window.location.href = '/admin/jobs/' + id + '/edit')
                    }
                />

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

export default JobsIndex
