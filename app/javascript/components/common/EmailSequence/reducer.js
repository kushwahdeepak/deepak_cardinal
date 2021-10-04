const reducer = (state, action) => {
    switch (action.type) {
        case 'changeState':
            var name = action.name
            var cloneState = state
            var cloneObject = cloneState[action.index]
            var newCloneObject = { ...cloneObject, [name]: action.value }
            cloneState[action.index] = newCloneObject
            return [...cloneState]
        case 'updateState':
            return [...action.value]
        case 'updateEmail':
            var cloneState = state
            cloneState[action.index] = action.value
            return [...cloneState]
        case 'clearState':
            var cloneState = state
            var cloneObject = cloneState[action.index]
            var newCloneObject = { ...cloneObject, subject: '', email_body: '' }
            cloneState[action.index] = newCloneObject
            return [...cloneState]
        case 'defult':
            return state
    }
}

export default reducer
