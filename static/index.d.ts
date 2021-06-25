/**
 * @fileoverview Declarations for the hand tracking API.
 */

/**
 * Represents pairs of (start,end) indexes so that we can connect landmarks
 * with lines to provide a skeleton when we draw the points.
 */
export declare type LandmarkConnectionArray = Array<[number, number]>;

/**
 * HandEvent.onHand returns an array of landmarks. This array provides the
 * edges to connect those landmarks to one another.
 */
export declare const HAND_CONNECTIONS: LandmarkConnectionArray;

/**
 * Represents a normalized rectangle. Has an ID that should be consistent
 * across calls.
 */
export declare interface NormalizedRect {
  xCenter: number;
  yCenter: number;
  height: number;
  width: number;
  rotation: number;
  rectId: number;
}

/**
 * Represents a single normalized landmark.
 */
export declare interface NormalizedLandmark {
  x: number;
  y: number;
  z: number;
  visibility?: number;
}

/**
 * Legal inputs for Hands.
 */
export interface Inputs {
  image: HTMLVideoElement;
}

/**
 * One list of landmarks.
 */
export type NormalizedLandmarkList = NormalizedLandmark[];

/**
 * Multiple lists of landmarks.
 */
export type NormalizedLandmarkListList = NormalizedLandmarkList[];

/**
 * GpuBuffers should not be modified by curious users, but by exposing this
 * directly, users can draw the result directly into a canvas context.
 */
type GpuBuffer = HTMLCanvasElement;

/**
 * The descriptiong of the hand represented by the corresponding landmarks.
 */
export interface Handedness {
  /**
   * Index of the object as it appears in multiHandLandmarks.
   */
  index: number;
  /**
   * Confidence score between 0..1.
   */
  score: number;
  /**
   * Identifies which hand is detected at this index.
   */
  label: 'Right'|'Left';
}

/**
 * Possible results from Hands.
 */
export interface Results {
  multiHandLandmarks?: NormalizedLandmarkListList;
  multiHandedness?: Handedness[];
  image: GpuBuffer;
}

/**
 * Configurable options for Hands.
 */
export interface Options {
  selfieMode?: boolean;
  maxNumHands?: number;
  minDetectionConfidence?: number;
  minTrackingConfidence?: number;
}

/**
 * Listener for any results from Hands.
 */
export type ResultsListener = (results: Results) => (Promise<void>|void);

/**
 * Contains all of the setup options to drive the hand solution.
 */
export interface HandsConfig {
  locateFile?: (path: string, prefix?: string) => string;
}

/**
 * Declares the interface of Hands.
 */
declare interface HandsInterface {
  close(): Promise<void>;
  onResults(listener: ResultsListener): void;
  initialize(): Promise<void>;
  send(inputs: Inputs): Promise<void>;
  setOptions(options: Options): void;
}

/**
 * Encapsulates the entire Hand solution. All that is needed from the developer
 * is the source of the image data. The user will call `send`
 * repeatedly and if a hand is detected, then the user can receive callbacks
 * with this metadata.
 */
export declare class Hands implements HandsInterface {
  constructor(config?: HandsConfig);

  /**
   * Shuts down the object. Call before creating a new instance.
   */
  close(): Promise<void>;

  /**
   * Registers a single callback that will carry any results that occur
   * after calling Send().
   */
  onResults(listener: ResultsListener): void;

  /**
   * Initializes the solution. This includes loading ML models and mediapipe
   * configurations, as well as setting up potential listeners for metadata. If
   * `initialize` is not called manually, then it will be called the first time
   * the developer calls `send`.
   */
  initialize(): Promise<void>;

  /**
   * Processes a single frame of data, which depends on the options sent to the
   * constructor.
   */
  send(inputs: Inputs): Promise<void>;

  /**
   * Adjusts options in the solution. This may trigger a graph reload the next
   * time the graph tries to run.
   */
  setOptions(options: Options): void;
}
