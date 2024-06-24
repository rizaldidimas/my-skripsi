distance_matrix = [
    0, 29, 20, 21, 16;
    29, 0, 15, 17, 28;
    20, 15, 0, 28, 18;
    21, 17, 28, 0, 25;
    16, 28, 18, 25, 0
];
% ACO parameters
num_ants = 10;
num_iterations = 100;
pheromone_evaporation = 0.5;
alpha = 1.0;
beta = 2.0;
% Initialize pheromone levels on each edge
pheromones = ones(size(distance_matrix));
% Main ACO algorithm
for iteration = 1:num_iterations
    ant_tours = {};

    for ant = 1:num_ants
        % Initialize an empty tour for each ant
        tour = [1];  % Start from city 1 (MATLAB indexing starts from 1)

        % Construct a tour by moving to other cities
        while length(tour) < size(distance_matrix, 1)
            current_city = tour(end);
            unvisited_cities = setdiff(1:size(distance_matrix, 1), tour);

            % Calculate the probabilities to move to unvisited cities
            probabilities = [];
            total_prob = 0;
            for city = unvisited_cities
                pheromone = pheromones(current_city, city);
                distance = distance_matrix(current_city, city);
                probability = (pheromone ^ alpha) * (1 / distance) ^ beta;
                probabilities = [probabilities, probability];
                total_prob = total_prob + probability;
            end
% Select the next city using roulette wheel selection
            roulette = rand() * total_prob;
            selected_city = [];
            for i = 1:length(probabilities)
                roulette = roulette - probabilities(i);
                if roulette <= 0
                    selected_city = unvisited_cities(i);
                    break;
                end
            end

            tour = [tour, selected_city];
        end

        % Add the last edge to return to the starting city
        tour = [tour, tour(1)];
        ant_tours{ant} = tour;
    end
  % Update pheromone levels
    pheromones = pheromones * (1 - pheromone_evaporation);
    for ant = 1:num_ants
        tour = ant_tours{ant};
        tour_length = sum(distance_matrix(tour(1:end-1), tour(2:end)));
        for i = 1:length(tour) - 1
            pheromones(tour(i), tour(i+1)) = pheromones(tour(i), tour(i+1)) + 1 / tour_length;
        end
    end

    % Find the best tour of this iteration
    best_length = Inf;
    best_tour = [];
    for ant = 1:num_ants
        tour = ant_tours{ant};
        tour_length = sum(distance_matrix(tour(1:end-1), tour(2:end)));
        if tour_length < best_length
            best_length = tour_length;
            best_tour = tour;
        end
        end

    disp(['Iteration ', num2str(iteration), ': Best tour length = ', num2str(best_length), ', Best tour = ', num2str(best_tour)]);
end
% Print the best tour found
disp(['Best tour found: ', num2str(best_tour)]);
