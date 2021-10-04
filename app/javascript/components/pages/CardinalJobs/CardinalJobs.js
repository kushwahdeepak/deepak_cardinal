import React, { useState, useEffect } from 'react'
import axios from 'axios'
import SearchResultsBlock from './../JobSearchPage/SearchResultsBlock/SearchResultsBlock'

const RESULTS_PER_PAGE = 25

const CardinalJobs = ({ userId, organization, currentUser }) => {
    const user = currentUser;
    const [cardinalJobs, setCardinalJobs] = useState([])
    const [loading, setLoading] = useState(false)
    const [inputValue, setInputValue] = useState('')
    const [activePage, setActivePage] = useState(0)
    const [totalJobsCount, setTotalJobsCount] = useState(0)
    const [totalPages, setTotalPages] = useState(0)
    const [errorSearchingJobs, setErrorSearchingJobs] = useState(null)
    const [experienceYears, setExperienceYears] = useState()
    const [filterStack, setFilterStack] = useState({
        skills: [],
        companyNames: [],
        keywords: [],
        locations:[]
    })

    const submitJobSearch = (event) => {
        event.preventDefault()
        setActivePage(0)
        handleSearch()
    }

    useEffect(() => {
        fetchJobsBySearch()
    }, [activePage])

    const handleInputChange = (value) => {
        setInputValue(value)
    }

    const fetchJobsBySearch = async () => {
        const url = '/jobs/cardinal_member_organization_jobs'
        setLoading(true)
        const CSRF_Token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute('content')

        try {
            const response = await axios.get(
                `${url}?page=${activePage + 1}`,
                {
                    headers: {
                        'content-type': 'application/json',
                        'X-CSRF-Token': CSRF_Token,
                    },
                }
            )
            const jobsData = response.data.jobs
            setCardinalJobs(jobsData)
        } catch (e) {
            console.error(e?.message)
            setErrorSearchingJobs(e?.message)
        }

        setLoading(false)
    }

    const handleSearch = async () => {
        const url = 'job_searches/search_cardinal_jobs'
        setLoading(true)
        const job_search = {
            keyword: inputValue
        }
        const payload = JSON.stringify({ job_search })
        const CSRF_Token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute('content')

        try {
            const response_new = await axios.post(
                `${url}?page=${activePage + 1}`,
                payload,
                {
                    headers: {
                        'content-type': 'application/json',
                        'X-CSRF-Token': CSRF_Token,
                    },
                }
            )

            const jobsData = response_new.data
            const jobs = jobsData.jobs
            // const totalCount = jobsData.total_count
            // const totalPages = jobsData.total_pages
            // setTotalJobsCount(totalCount)
            // setTotalPages(totalPages)
            setCardinalJobs(jobs)
        } catch (e) {
            console.error(e.message)
            setErrorSearchingJobs(e.message)
        }
        setLoading(false)
    }
    return (
        <div className="job-search-page">
            <div>
                <>
                    <SearchResultsBlock
                        totalJobsCount={totalJobsCount}
                        pageCount={totalPages}
                        activePage={activePage}
                        jobs={cardinalJobs}
                        loading={loading}
                        submitJobSearch={submitJobSearch}
                        handleInputChange={handleInputChange}
                        inputValue={inputValue}
                        setActivePage={setActivePage}
                        errorSearchingJobs={errorSearchingJobs}
                        setErrorSearchingJobs={setErrorSearchingJobs}
                        filterStack={filterStack}
                        setStackFilter={setFilterStack}
                        // handleSearch={handleFilter}
                        experienceYears={experienceYears}
                        setExperienceYears={setExperienceYears}
                        user={user}
                    />

                </>
            </div>
        </div>
    )
}

export default CardinalJobs
