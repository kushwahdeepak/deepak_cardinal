import { act } from 'react-dom/test-utils'

export const findByTestAttr = (wrapper, attr) => {
    return wrapper.find(`[data-test='${attr}']`)
}

export const timeoutResolve = (time = 0, response = {}) =>
    new Promise((resolve) => {
        setTimeout(() => resolve(response), time)
    })

export const wait = (time = 0) => {
    const timer = timeoutResolve(time)

    return act(async () => {
        await timer
    })
}
export function emailIsValid(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
}

export function generateRandom(min, max) {
    return Math.floor(min + Math.random() * (max + 1 - min))
}

export function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1).toLowerCase()
}

export function createMarkedList(array) {
    if (!Array.isArray(array)) {
        return []
    }
    return array.map((candidate) => ({
        id: candidate.id,
        name: candidate.id,
        fullName: `${candidate.first_name} ${candidate.last_name}`,
        emailAddress: candidate.email_address,
        isChecked: false,
    }))
}

export function stringReplace(string,toSymbol,fromSymbol){
    return string.replace(toSymbol, fromSymbol)
}

export function capitalize(string) {
    return string.replace(/\b(\w)/g, s => s.toUpperCase());
}

export function skillIsNotEmpty(value){
    return value.trim().length > 0;
}

export function firstCharacterCapital(value){
    return value?.charAt(0)?.toUpperCase() + value?.slice(1)
}
