import React, { useState, useEffect, useReducer, useMemo } from 'react'
import FilterStack from '../FilterStack/FilterStack'
import styles from './styles/CandidateManager.module.scss'
import axios from 'axios'
import uniqBy from 'lodash.uniqby'
import isNil from 'lodash.isnil'
import Alert from 'react-bootstrap/Alert'
import CandidateTable from '../CandidateTable/CandidateTable'
import ScheduleModal from '../ScheduleModal/ScheduleModal'
import RecruitingActivity from '../RecruitingActivity/RecruitingActivity'
import CandidateInfoPanel from '../CandidateInfoPanel/CandidateInfoPanel'
import EmailClient from '../EmailClient/EmailClient'
import { nanoid } from 'nanoid'
import ButtonGroup from 'react-bootstrap/ButtonGroup'
import Button from 'react-bootstrap/Button'
import _ from 'lodash'
import {
    initialState,
    reducer,
    StoreDispatchContext,
} from '../../../stores/JDPStore'
import Util from '../../../utils/util'
import SearchBar from '../SearchBar/SearchBar'
import RenderInterviewScheduleDetails from '../../common/ScheduleInterviewDetails/RenderInterviewScheduleDetails'

const ALL_LEADS = 'all_leads'
// const MY_LEADS = 'my_leads'
// const TEAMS_LEADS = 'team_leads'

const EMPTY_FILTERS = {
    titles: [],
    locations: [],
    skills: [],
    tags: [],
    company_names: [],
    top_company: false,
    schools: [],
    disciplines: [],
    degrees: [],
    top_school: false,
    active: false,
    phone_number_available: false,
    names: [],
    emails: [],
    email_type: '',
    keyword: '',
    withinPeriodKey: '',
    city: [],
    state: [],
}

function CandidateManager(props) {
   const {
        user,
        candidateSource,
        title = '',
        jobId = -1,
        fullJob,
        tableColumns,
        showSearchField = false,
        enableStages = true,
        allowCandidateUpload = false,
        isEmailConfigured,
        stage,
        showUploadCandidatePanel,
        setShowUploadCandidatePanel,
        currentOrganization,
        jobs,
        candidatePage,
        memberOrganization,
        placeholder,
        showdisplaycount=true
    } = props
    const [loading, setLoading] = useState(false)
    const [totalCandidateCount, setTotalCandidateCount] = useState(0)
    const [pageCount, setPageCount] = useState(0)
    const [page, setPage] = useState(0)
    const [searchText, setSearchText] = useState('')
    const [activeLeadsTab, setActiveLeadsTab] = useState(ALL_LEADS)
    const [showScheduleModal, setShowScheduleModal] = useState(false)
    const [allSelectedCandidates, setAllSelectedCandidates] = useState([])
    const [modalShow, setModalShow] = useState(false)
    const [interviewModal,setInterviewModal] =useState([])
    const [successFormSubmitting, setSuccessFormSubmitting] = useState('')
    const [reloadCandidateData, setReloadCandidateData] = useState(false)
    // This refers to the column of filters which may be added/removed individually
    const [filterStack, setFilterStack] = useState(EMPTY_FILTERS)

    const [state, dispatch] = useReducer(reducer, initialState)
    const [apiCallFrom, setApiCallFrom] = useState('search')
    const [totalPersonCount, setTotalPersonCount] = useState(0)
    const [haveFilter, setHaveFilter] = useState(false)

    // Feature flag
    const showRecruitingFilters = true

    const candidateManagerId = nanoid()

    const setFilterData = (attr, val) => {
        const newFilterStack = { ...filterStack, [attr]: val }

        if(!_.isEqual(filterStack,newFilterStack)) {
            setFilterStack(newFilterStack)
        }
    }
    const refreshCandidateData = async () => {
        setLoading(true)
        let page_num = 0
        if(apiCallFrom === 'pagination') {
            page_num = page
        } else {
            setPage(0)
            setApiCallFrom('search')
            page_num = 0
        }
        const result = await fetchCandidates(
            candidateSource,
            page_num,
            null,
            jobId,
            formatFiltersForSearch(filterStack),
            stage
        )

        dispatch({
            type: 'set_candidates',
            candidates: result.candidates,
        })
        setTotalCandidateCount(result.totalCandidateCount)
        setPageCount(result.pageCount)
        setTotalPersonCount(result.total_persons)
        setLoading(false)
    }

    useEffect(() => {
        ;(async () => {
            const allSelectedCandidates = await fetchAllSelectedCandidates(
                state,
                filterStack,
                candidateSource,
                jobId,
                stage
            )

            setAllSelectedCandidates(allSelectedCandidates)
        })()
    }, [state.selectedCandidates, filterStack, candidateSource, jobId, stage])

    useEffect(() => {
        setApiCallFrom('search')
        refreshCandidateData()
    }, [filterStack, page, stage, reloadCandidateData])

    // deselect everyone when filters are modified
    useEffect(() => {
        dispatch({ type: 'deselect_all' })
    }, [filterStack])

    useEffect(() => {
        dispatch({ type: 'set_user', user })
    }, [])

    const handleModal = () => {
        setShowScheduleModal(false)
    }

    const handleInterviewModal = (value) => {
       setInterviewModal(value)
       if(!modalShow){
            setModalShow(true)
        }
    }
      
    const interviewDetails = () => {
      return(
            <RenderInterviewScheduleDetails
              show={modalShow}
              hideModal={() => setModalShow(false)}
              interviewModal={interviewModal}
            />
      )
    }

    useEffect(() => {
        let arr = []
        Object.keys(filterStack).map(function(key, inex) {
            if(typeof filterStack[key] == "boolean") {
                filterStack[key] ? arr.push(true) : arr.push(false)
            } else {
                filterStack[key].length > 0 ? arr.push(true) : arr.push(false)
            }
        })
        arr.includes(true) ? setHaveFilter(true) : setHaveFilter(false)
    }, [filterStack])

    function renderDisplayCount(){
        return(
            <span className={candidatePage ?  styles.candidatecount : styles.resultCount}>
                Displaying{' '}
                {Util.displayNumberOfResults(
                    totalCandidateCount,
                    pageCount,
                    page,
                    25, // candidates per page,
                    haveFilter ? (totalCandidateCount >= 1000 ? `${totalCandidateCount}+` : totalCandidateCount) : totalPersonCount,
                    true,
                    showdisplaycount
                )}
            </span>
        )
    }

    function handlePageChangeClick(page_num) {
        setPage(page_num)
        setApiCallFrom('pagination')
    }
    return (
        <StoreDispatchContext.Provider value={{ state, dispatch }}>
            {successFormSubmitting && (
                <Alert
                    style={{ flexGrow: '1' }}
                    variant="success"
                    onClose={() =>
                        setSuccessFormSubmitting(null)
                    }
                    dismissible
                >
                    {successFormSubmitting}
                </Alert>
            )}
            <div className={styles.mainContainer}>
                {/* Filters column */}
                <div className={styles.filtersColumn}>
                    {showRecruitingFilters && !candidatePage && (
                        <RecruitingActivity
                            setSelectWithinValue={(val) => {
                                setFilterData('withinPeriodKey', val)
                            }}
                        />
                    )}
                    <FilterStack
                        candidatePage={candidatePage}
                        filterStack={filterStack}
                        setFilterData={setFilterData}
                        setFilterStack={setFilterStack}
                        emptyFilter={EMPTY_FILTERS}
                        currentOrganization={currentOrganization}
                        memberOrganization={memberOrganization}
                        currentUser={user}
                        jobId={jobId}
                        closeFunc={
                            showUploadCandidatePanel === undefined
                                ? () => {
                                      dispatch({ type: 'hide_candidate' })
                                  }
                                : () => {
                                      setShowUploadCandidatePanel(false)
                                      dispatch({ type: 'hide_candidate' })
                                  }
                        }
                    />
                </div>
                
                {/* Candidates table column */}
                <div className={styles.tableColumn}>
                    <div className={candidatePage ? '' : styles.tableContainer}>
                        <div className={styles.tableHeader}>
                            <div className={styles.tableTitleBlock}>
                                {stage !== 'lead' ? (
                                    <h3 className={styles.tableTitle}>
                                        {title}
                                    </h3>
                                ) : (
                                    ''
                                )}
                                {/* <ButtonGroup>
                                         <Button
                                            style={{
                                                background: `${
                                                    activeLeadsTab === ALL_LEADS
                                                        ? '#4C68FF'
                                                        : ' #EBEDFA'
                                                }`,
                                                color: `${
                                                    activeLeadsTab === ALL_LEADS
                                                        ? ' #EBEDFA'
                                                        : '#4C68FF'
                                                }`,
                                            }}
                                            className={styles.jobButton}
                                            onClick={() =>
                                                setActiveLeadsTab(ALL_LEADS)
                                            }
                                        >
                                            All Leads
                                        </Button>
                                        <Button
                                            style={{
                                                background: `${
                                                    activeLeadsTab === MY_LEADS
                                                        ? '#4C68FF'
                                                        : ' #EBEDFA'
                                                }`,
                                                color: `${
                                                    activeLeadsTab === MY_LEADS
                                                        ? ' #EBEDFA'
                                                        : '#4C68FF'
                                                }`,
                                            }}
                                            className={styles.jobButton}
                                            onClick={() =>
                                                setActiveLeadsTab(MY_LEADS)
                                            }
                                        >
                                            {' '}
                                            My Leads
                                        </Button>
                                        <Button
                                            style={{
                                                background: `${
                                                    activeLeadsTab ===
                                                    TEAMS_LEADS
                                                        ? '#4C68FF'
                                                        : ' #EBEDFA'
                                                }`,
                                                color: `${
                                                    activeLeadsTab ===
                                                    TEAMS_LEADS
                                                        ? ' #EBEDFA'
                                                        : '#4C68FF'
                                                }`,
                                            }}
                                            className={styles.jobButton}
                                            onClick={() =>
                                                setActiveLeadsTab(TEAMS_LEADS)
                                            }
                                        >
                                            {' '}
                                            Team's Leads
                                        </Button>
                                    </ButtonGroup> */}
                                {/* )} */}
                               {candidatePage ? ' ' : renderDisplayCount()}
                            </div>
                            {showSearchField && (
                                <SearchBar
                                    candidatePage={candidatePage}
                                    hideButton={!candidatePage}
                                    placeholder={placeholder}
                                    value={searchText}
                                    onButtonClick={(event) => {
                                        event.preventDefault()
                                        setPage(0)
                                        setFilterData('keyword', searchText)
                                    }}
                                    onEnterPressed={(event) => {
                                        setPage(0)
                                        setFilterData('keyword', searchText)
                                    }}
                                    onChange={(event) => {
                                        const text = event.target.value
                                        setSearchText(text)

                                        // We don't want to trigger a change to filterStack on every character
                                        // change since a new search would be performed each time, but we
                                        // want filterStack['keyword'] to have the latest value at all times.
                                    }}
                                    candidateSource={candidateSource}
                                />
                            )}
                        </div>
                        <CandidateTable
                            candidatePage={candidatePage}
                            displayCount={renderDisplayCount()}
                            columns={tableColumns}
                            loading={loading}
                            candidates={state.candidates}
                            page={page}
                            jobId={jobId}
                            stage={stage}
                            handlePageChangeClick={handlePageChangeClick}
                            totalPages={pageCount}
                            enableStages={enableStages}
                            totalCandidateCount={totalCandidateCount}
                            refreshCandidates={refreshCandidateData}
                            allSelectedCandidates={allSelectedCandidates}
                            jobs={jobs}
                            candidateSource={candidateSource}
                        />
                    </div>
                </div>
            </div>
            { showScheduleModal && (
                <ScheduleModal
                    show={showScheduleModal}
                    onHide={handleModal}
                    onInterview={handleInterviewModal}
                    user={state.user ?? { id: -1 }}
                    candidate={state.displayedCandidate}
                    jobs={jobs}
                    fullJob={fullJob}
                />
            )}
            {modalShow && interviewDetails() }
            <CandidateInfoPanel 
                user = {user}
                candidate={state.displayedCandidate}
                closeFunc={
                    showUploadCandidatePanel === undefined
                        ? () => {
                              dispatch({ type: 'hide_candidate' })
                          }
                        : () => {
                              setShowUploadCandidatePanel(false)
                              dispatch({ type: 'hide_candidate' })
                          }
                }
                handleScheduleButtonClick={() => setShowScheduleModal(true)}
                showUploadCandidatePanel={showUploadCandidatePanel}
                memberOrganization={memberOrganization}
                page={page}
                setPage={setPage}
                pageCount={pageCount}
                jobId={jobId}
                currentOrganization={currentOrganization}
                reloadCandidateData={reloadCandidateData}
                setReloadCandidateData={setReloadCandidateData}
                allowCandidateUpload={allowCandidateUpload}
            />
            {!state.displayedCandidate &&
              <EmailClient
                  emailClientId={'emailclientfor_' + candidateManagerId}
                  userId={user.id}
                  isEmailConfigured={isEmailConfigured}
                  jobId={jobId}
                  userEmail={user.email}
                  showByDefault={false}
                  mailSentCallback={() => refreshCandidateData()}
                  sendList={allSelectedCandidates}
                  candidateCount={state.candidates}
                  // totalCandidateCount={totalCandidateCount}
                  setSuccessFormSubmitting={setSuccessFormSubmitting}
                  successFormSubmitting={successFormSubmitting}
              />
            }
        </StoreDispatchContext.Provider>
    )
}

const fetchCandidates = async (
    candidateSource,
    page,
    count,
    jobId,
    filters,
    stage
) => {
    // Local pagination is 0-based, but API is 1-based
    if (!isNil(page)) {
        page += 1
    }

    if (candidateSource === 'submitted_candidates') {
        return await fetchApplicants(page, count, jobId, stage, filters)
    } else if (candidateSource === 'lead_candidate_search') {
        return await fetchCandidatesFromSearch(
            page,
            count,
            jobId,
            filters,
            true
        )
    } else if (candidateSource === 'candidate_search') {
        return await fetchCandidatesFromSearch(
            page,
            count,
            jobId,
            filters,
            false
        )
    } else {
        return { candidates: [] }
    }
}

const fetchApplicants = async (page, count, jobId, stage, filters) => {
    const payload = JSON.stringify({
        filters,
        page: !isNil(page) ? page : undefined,
        count: !isNil(count) ? count : undefined,
        job_id: jobId,
        period_key: filters.withinPeriodKey,
        stage,
    })

    const CSRF_Token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute('content')
    const response = await axios.post(
        `/jobs/fetch_submitted_candidates`,
        payload,
        {
            headers: {
                'content-type': 'application/json',
                'X-CSRF-Token': CSRF_Token,
            },
        }
    )
     
    const uniqCandidates = uniqBy(response.data.submitted_candidates, 'id')
        .filter((person) => isNil(stage) || person.stage === stage)
        .map((person) => transformPersonModel(person))
    return {
        candidates: response.data.submitted_candidates,
        totalCandidateCount: response.data.total_count, // WTODO need something along these lines that takes into account stages: response.data.total_count,
        pageCount: response.data.total_pages || 1,
    }
}

const fetchCandidatesFromSearch = async (
    page,
    count,
    jobId,
    filters,
    with_score
) => {
    let new_location = []
    if(filters.city)
    {
        const cities = filters.city.split(',')
        cities.map((ct, i)=>{
        if(i == 0) {
            new_location.push(ct)
        } else if(i%3 == 0) {
            new_location.push(ct)
        }

        })
        filters.locations = new_location.join(',')
    } else if(filters.state) {
        filters.locations = filters.state
    }
    const payload = JSON.stringify({
        filters,
        page: !isNil(page) ? page : undefined,
        count: !isNil(count) ? count : undefined,
        job_id: jobId,
        period_key: filters.withinPeriodKey,
        with_score: with_score,
    })

    const CSRF_Token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute('content')

    const response = await axios.post('/people/search', payload, {
        headers: {
            'content-type': 'application/json',
            'X-CSRF-Token': CSRF_Token,
        },
    })
     
    const uniqCandidates = uniqBy(response.data.people, 'id').map((person) =>
        transformPersonModel(person)
    )

    return {
        candidates: uniqCandidates,
        totalCandidateCount: response.data.total,
        pageCount: response.data.total_pages,
        total_persons: response.data.total_persons
    }
}

/**
 * Fetches an arbitrary number of candidates, potentially spanning multiple pages.
 * @param {*} n The number of candidates to fetch
 * @param {*} filterStack The filters to use
 * @param {*} candidateSource Where we are fetching from (this is an enum value)
 * @param {*} jobId The job candidates are associated with
 */
const fetchNCandidates = async (
    n,
    filterStack,
    candidateSource,
    jobId,
    stage
) => {
    if (n === 0) return []

    return (
        (
            await fetchCandidates(
                candidateSource,
                null,
                n,
                jobId,
                formatFiltersForSearch(filterStack),
                stage
            )
        ).candidates ?? []
    )
}

const fetchAllSelectedCandidates = async (
    state,
    filterStack,
    candidateSource,
    jobId,
    stage
) => {
    const numCandidates = Math.min(
        state.selectionLimit,
        state.selectedCandidates.length
    )
    const fullCandidateData = await fetchNCandidates(
        numCandidates,
        filterStack,
        candidateSource,
        jobId,
        stage
    )

    const allSelectedCandidates = fullCandidateData.filter(
        (candidate, i) => state.selectedCandidates[i]
    )

    // We only fetch full candidate data up to state.selectionLimit above,
    // so here we add in any candidates which were selected outside the
    // selection limit.
    for (
        let i = state.selectionLimit;
        i < state.selectedCandidates.length;
        i++
    ) {
        if (!isNil(state.selectedCandidates[i])) {
            allSelectedCandidates.push(state.selectedCandidates[i])
        }
    }

    return allSelectedCandidates
}

function transformPersonModel(model) {
    // Replace null/undefined on person models with empty strings to avoid
    // unnecessary null pointers
    Object.keys(model).forEach((key) => {
        if (isNil(model[key])) {
            model[key] = ''
        }
    })

    const charsToStrip = /\[|\]|\"/g

    return {
        ...model,
        company_names: model.company_names?.replace(charsToStrip, '') ?? '',
        skills: model.skills?.replace(charsToStrip, '') ?? '',
        tags: model.tags?.replace(charsToStrip, '') ?? '',
    }
}

function candidatePassesAllFilters(candidate, filterStack, filterText) {
    const textFilterAttrs = [
        'first_name',
        'last_name',
        'title',
        'location',
        'school',
        'skills',
        'company_names',
    ]
    const passedTextFilter = true
    Util.objectPassesTextFilter(candidate, textFilterAttrs, filterText)

    return passedTextFilter && passesFilterStack(filterStack, candidate)
}

function passesFilterStack(filters, candidate) {
    return Object.values(filters)
        .filter((testFunc) => typeof testFunc === 'function')
        .reduce((passes, testFunc) => passes && testFunc(candidate), true)
}

function formatFiltersForSearch(filterStack) {
    const clone = {}

    Object.keys(filterStack).forEach((key) => {
        const filter = filterStack[key]
        clone[key] = Array.isArray(filter) ? filter.join(',') : filter
    })

    return clone
}

export default CandidateManager
