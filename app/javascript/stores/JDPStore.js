import React from 'react'
import Util from '../utils/util'

const initialState = {
    displayedCandidate: null,
    selectedCandidates: [], // This stores booleans indicating whether a candidate is selected. The ordering matches that of the search results.
    selectAllChecked: false,
    selectionLimit: 200,
    scheduleModalData: {},
    user: null,
    nextCandidateId: null,
}

const reducer = (state, action) => {
    switch (action.type) {
        case 'set_candidates':
            return { ...state, candidates: action.candidates }
        case 'update_candidate':
            return {
                ...state,
                candidates: Util.replaceInArrayCopy(
                    state.candidates,
                    action.candidate
                ),
            }
        case 'update_schedule_modal_data':
            return {
                ...state,
                scheduleModalData: {
                    ...state.scheduleModalData,
                    ...action.data,
                },
            }
        case 'show_candidate':
            return { ...state, displayedCandidate: action.candidate }
        case 'hide_candidate':
            return { ...state, displayedCandidate: null }
        case 'set_selection_limit':
            return {
                ...state,
                selectedCandidates: state.selectedCandidates.slice(
                    0,
                    action.limit
                ),
                selectionLimit: action.limit,
            }
        case 'select_up_to_limit':
            return {
                ...state,
                selectedCandidates: createSelectedCandidatesArray(action.limit),
                selectAllChecked: true,
                selectionLimit: action.limit,
            }
        case 'deselect_all':
            return { ...state, selectedCandidates: [], selectAllChecked: false }
        case 'toggle_candidate_selection':
            return {
                ...state,
                selectedCandidates: Util.replaceInArrayCopy_i(
                    state.selectedCandidates,
                    action.index,
                    action.candidate
                ),
            }
        case 'set_user':
            return { ...state, user: action.user }
        case 'set_show_next_candidate':
            return { ...state, nextCandidateId: action.index }
        case 'remove_show_next_candidate':
            return { ...state, nextCandidateId: null }
        default:
            return state
    }
}

function createSelectedCandidatesArray(length) {
    const a = []
    for (let i = 0; i < length; i++) {
        a[i] = true
    }
    return a
}

const StoreDispatchContext = React.createContext(null)

export { initialState, reducer, StoreDispatchContext }
