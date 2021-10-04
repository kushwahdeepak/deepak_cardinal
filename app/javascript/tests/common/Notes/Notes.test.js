import React from 'react';
import Notes from '../../../components/common/Notes/Notes';
import renderer from 'react-test-renderer';
import { configure, shallow, mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { findByTestAttr, wait } from '../../../utils';
import { act } from 'react-dom/test-utils';

configure({adapter: new Adapter()});

const initialShallowRender = (props = {}) => {
	return shallow(<Notes {...props}/>);
};

const initialMountRender = (props = {}) => {
	return mount(<Notes {...props}/>);
};

const initialProps = {
	candidate: []
};

describe('Notes component',  () => {
	let wrapper;
	let fullWrapper;

	beforeEach(() => {

		const props = {
			...initialProps
		};

		wrapper = initialShallowRender(props);
		fullWrapper = initialMountRender(props);
	});

	it('should render Notes component', () => {
		expect(wrapper.exists()).toBe(true);
	});

	it('should match with a snapshot', () => {
		const component = renderer.create(<Notes />);
		let tree = component.toJSON();
		expect(tree).toMatchSnapshot();
	});

	describe('AddNote component with props', () => {
		let wrapper;
		let fullWrapper;
		const actions = async (wrapper, _actions) => {
			await act(async () => {
				await (new Promise(resolve => setTimeout(resolve, 0)));
				_actions();
				wrapper.update();
			});
		};

		beforeEach(() => {
			const props = {
				...initialProps,
			};

			wrapper = initialShallowRender(props);
			fullWrapper = initialMountRender(props);
		});

		afterEach(() => {
			jest.clearAllMocks();
		});


		it('should open Notes modal window', () => {
			const openBtn = () => findByTestAttr(fullWrapper, 'open-modal-btn').at(0);
			const modalWrapper = () => findByTestAttr(fullWrapper, 'modal-wrapper').at(0);
			openBtn().simulate('click');

			fullWrapper.update();
			expect(modalWrapper().exists()).toBeTruthy();
		});

		it('should have expected content in Notes modal window', () => {
			const expectedTitle = 'Add New Note';
			const expectedButton = 'Add';
			const openBtn = () => findByTestAttr(fullWrapper, 'open-modal-btn').at(0);
			const modalTitle = () => findByTestAttr(fullWrapper, 'notes-modal-title').at(0);
			const addModalBtn = () => findByTestAttr(fullWrapper, 'add-modal-btn').at(0);
			openBtn().simulate('click');

			const titleText = modalTitle().text();
			const addBtnText = addModalBtn().text();
			fullWrapper.update();
			expect(titleText).toBe(expectedTitle);
			expect(addBtnText).toBe(expectedButton);
		});

		it('should close Notes modal window', async () => {
			const openBtn = () => findByTestAttr(fullWrapper, 'open-modal-btn').at(0);
			const closeButton = () => findByTestAttr(fullWrapper, 'close-button').at(0);
			const modalWrapper = () => findByTestAttr(fullWrapper, 'modal-wrapper').at(0);
			openBtn().simulate('click');
			closeButton().simulate('click');

			fullWrapper.update();
			expect(modalWrapper().exists()).toBeFalsy();
		});

		it.skip('should call onClick handler', async () => {
			const setShowAddNoteModal = jest.fn();
			const handleClick = jest.spyOn(React, "useState");
			handleClick.mockImplementation(size => [size, setShowAddNoteModal]);
			const openBtn = () => findByTestAttr(wrapper, 'open-modal-btn').at(0);
			const closeButton = () => findByTestAttr(fullWrapper, 'close-button').at(0);

			openBtn().simulate('click');
			expect(setShowAddNoteModal).toHaveBeenCalledTimes(1);
		});
	});
});
