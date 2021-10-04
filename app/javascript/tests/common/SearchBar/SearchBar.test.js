import React from 'react';
import SearchBar from '../../../components/common/SearchBar/SearchBar';
import renderer from 'react-test-renderer';
import { configure, shallow, mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { findByTestAttr } from '../../../utils';

configure({adapter: new Adapter()});

const initialShallowRender = (props = {}) => {
	return shallow(<SearchBar {...props}/>);
};

const initialMountRender = (props = {}) => {
	return mount(<SearchBar {...props}/>);
};

describe('SearchBar component',  () => {
	let wrapper;
	let fullWrapper;

	beforeEach(() => {

		const props = {
		};
		wrapper = initialShallowRender(props);
		fullWrapper = initialMountRender(props);
	});

	afterEach(() => {
		fullWrapper.unmount();
	});

	it('should render SearchBar component', () => {
		expect(wrapper.exists()).toBe(true);
	});

	it('should match with a snapshot', () => {
		const component = renderer.create(<SearchBar />);
		let tree = component.toJSON();
		expect(tree).toMatchSnapshot();
	});

});
